require 'spec_helper'

describe Posting::CommentsController do
  describe "routing" do
    it 'recognizes #new' do
      { :get => 'postings/42/comments' }.should route_to(:controller => 'posting/comments', :action => 'index', :posting_id => '42')
    end
    
    it 'recognizes posting_comments_path' do
      posting_comments_path('42').should == '/postings/42/comments'
    end
    
    it 'recognizes #new' do
      { :get => 'postings/42/comments/new' }.should route_to(:controller => 'posting/comments', :action => 'new', :posting_id => '42')
    end

    it 'recognizes new_posting_comment_path' do
      new_posting_comment_path('42').should == '/postings/42/comments/new'
    end

    it 'recognizes #create' do
      { :post => 'postings/42/comments' }.should route_to(:controller => 'posting/comments', :action => 'create', :posting_id => '42')
    end
   
    it 'recognizes posting_comments_path' do
      posting_comments_path('42').should == '/postings/42/comments'
    end
  end
end
