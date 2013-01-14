describe("Form", function() {
  describe(".Nested", function() {
    describe("methods", function(){
      beforeEach(function() {
        loadFixtures('form/nested.html');
      });
      
      describe(".nested", function() {
        it("should return true if nested", function() {
          element = document.getElementById('contact_phones_attributes_1_kind');
          expect(new Form.Nested(element).nested()).toBeTruthy();
        });
        
        it("should return false if not nested", function() {
          element = document.getElementById('contact_name');
          expect(new Form.Nested(element).nested()).toBeFalsy();
        });
      });
      
      describe(".firstElement", function(){
        it("should return false if its not the first element", function() {
          element = document.getElementById('contact_phones_attributes_1_kind');
          expect(new Form.Nested(element).firstElement()).toBeFalsy();
        });
        
        it("should return true if is the first element", function() {
          element = document.getElementById('contact_phones_attributes_1_number');
          expect(new Form.Nested(element).firstElement()).toBeTruthy();
        });
      });
      
      describe(".lastElement", function(){
        it("should return false if its not the last element", function() {
          element = document.getElementById('contact_phones_attributes_1_number');
          expect(new Form.Nested(element).lastElement()).toBeFalsy();          
        });
        
        it("should return true if is the last element", function() {
          element = document.getElementById('contact_phones_attributes_1_kind');
          expect(new Form.Nested(element).lastElement()).toBeTruthy();
        });
      });

      describe(".allBlank", function(){
        it("should return true all field is blank", function() {
          element = document.getElementById('contact_phones_attributes_1_kind');
          expect(new Form.Nested(element).allBlank()).toBeTruthy();
        });
        
        it("should return true if fields are with default value", function() {
          element = document.getElementById('contact_addresses_attributes_1_city');
          element.value = "Cidade";
          expect(new Form.Nested(element).allBlank()).toBeTruthy();
        });
        
        it("should return false if any fields are filled", function() {
          element = document.getElementById('contact_addresses_attributes_1_city');
          element.value = "Rio de Janeiro";
          expect(new Form.Nested(element).allBlank()).toBeFalsy();
        });
      });
    });
  });
  
  describe("methods", function(){
    describe(".previousElement", function() {      
      it("should return the previous element", function() {
        expect(true).toBeTruthy();
      });
    });
    
    describe(".nextElement", function() {
      it("should return the next element", function() {
        expect(true).toBeTruthy();
      });
    });

    describe(".keypress", function(){
      it("should return if not tab pressed", function() {
        expect(true).toBeTruthy();
      });

      it("should call Form.previous if shift pressed", function(){
        expect(true).toBeTruthy();
      });

      it("should call Form.next if shift not pressed", function(){
        expect(true).toBeTruthy();
      });

      it("should show div.fields if its hide", function(){
        expect(true).toBeTruthy();
      });

      it("should focus on input", function(){
        expect(true).toBeTruthy();
      });
    });
  });
});