# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe Permalink do
  it "should remove consecutive underscores" do
    Permalink.make("a_______b").should == "a_b"
  end

  it "should remove accents" do
    Permalink.make("áéíóú").should == "aeiou"
  end

  it "should lowercase the text" do
    Permalink.make("ABCDE").should == "abcde"
  end
end
