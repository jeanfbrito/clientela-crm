describe("Contact", function() {
  beforeEach(function() {
    toHaveAnEventOn = function(eventType, obj, method) {
      var result = false;
      $.each(obj.data('events'), function(name, handler){
        if(name != eventType) {
          return;
        }
        $.each(handler, function(i,handlerItem){
          if(method.toString().trim() == handlerItem.handler.toString().trim()) {
            result = true;
          }
        });
      });
      return result;
    }
    
    this.addMatchers({
      toHaveNoFields: function() {
        return ($('div#phones-fields').children().size() == 0);
      },

      toHaveOneField: function() {
        return ($('div#phones-fields').children().size() == 1);
      },
      
      toHaveTwoFields: function() {
        return ($('div#phones-fields').children().size() == 2);
      },

      toHaveOnKeypress: function(method) {
        return toHaveAnEventOn('keypress', this.actual, method);
      },

      toHaveOnBlur: function(method) {
        return toHaveAnEventOn('blur', this.actual, method);
      }
    });

    loadFixtures('fresh-contact-form.html');
    Contact.ready();
    mockGetTime();
  });

  describe("methods", function(){
    xdescribe(".addNestedChildAfterTab", function() {
      var eventTabMock = {
        keyCode: Key.TAB,
        shiftKey: false,
        data: {
          assoc: 'company'
        }
      }

      var eventNonTabMock = {
        keyCode: Key.OTHER,
        shiftKey: false,
        data: {
          assoc: 'company'
        }
      }
      
      it("should call addNestedChild if Tab pressed", function() {
        spyOn(Contact, 'addNestedChild');
        
        result = Contact.addNestedChildAfterTab(eventTabMock);
        expect(Contact.addNestedChild).toHaveBeenCalledWith('phones');
        expect(result).toBeFalsy();
      });
      
      it("should not call addNestedChild if not-Tab pressed", function() {
        spyOn(Contact, 'addNestedChild');
        result = Contact.addNestedChildAfterTab(eventNonTabMock);
        expect(Contact.addNestedChild).not.toHaveBeenCalled();
        expect(result).toBeTruthy();
      });
      
      it("should not create other if already exists", function() {
        Contact.addNestedChild('phones');
        
        spyOn(Contact, 'addNestedChild');
        result = Contact.addNestedChildAfterTab(eventTabMock);
        expect(Contact.addNestedChild).not.toHaveBeenCalled();
        expect(result).toBeTruthy();
      });
    });
    
    xdescribe(".deleteNestedOnBlurWhenBlank", function() {
      it("should remove all div container", function() {
        Contact.addNestedChild('phones');
        expect().toHaveOneField();

        var event = {
          target: document.getElementById('contact_phones_attributes_1_kind'),
          data: {
            assoc: 'phones'
          }          
        };

        Contact.deleteNestedOnBlurWhenBlank(event);
        expect().toHaveNoFields();
      });
    });

    describe(".addNestedChild", function(){
      var new_phone_form;

      beforeEach(function () {
        expect().toHaveOneField();
        Contact.addNestedChild('phones');
        new_phone_form = $('div#phones-fields').children().last();
      });

      it("should have focus on first element", function() {
        expect(new_phone_form.children("input").first()).toHaveFocus();
      });

      it("should create a new phone form", function(){
        expect().toHaveTwoFields();
      });

      it("should create a new phone number input", function(){
        expect(new_phone_form.children("input#contact_phones_attributes_1_number")).toExist();
      });

      it("should create a new phone kind select", function(){
        expect(new_phone_form.children("select#contact_phones_attributes_1_kind")).toExist();
      });

      it("should create a new remove child", function(){
        expect(new_phone_form.children("a.remove_child")).toExist();
      });
    });
  });

  describe("events", function(){
    it("should a.add_child call Contact.addNestedChild()", function() {
      spyOn(Contact, 'addNestedChild');

      expect($('form a.add_child').size()).toEqual(4);

      $('form a.add_child').each(function() {
        var add_phone_link = $(this);
        add_phone_link.click();
        expect(Contact.addNestedChild).toHaveBeenCalledWith(add_phone_link.attr('data-association'));
      });
    });

    xit("should have onblur on last field input", function() {
      pressKeyTabOnId('contact_company_name');

      expect($('#contact_phones_attributes_1_number')).toHaveOnKeypress(Contact.goToNext);
      expect($('#contact_phones_attributes_1_kind')).toHaveOnBlur(Contact.addNestedChildAfterTab);
      expect($('#contact_phones_attributes_1_kind')).toHaveOnBlur(Contact.deleteNestedOnBlurWhenBlank);
    });

    xit("should have onkeypress on company name to add child phones on tab press", function() {
      expect($('#contact_company_name')).toHaveOnKeypress('function (event) {return Contact.addNestedChildAfterTab(event);}');
    });
  });
});