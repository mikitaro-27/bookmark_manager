require 'bookmark'
require 'database_helpers'

describe Bookmark do
  
  let(:url) { 'http://www.youtube.com/' }
  let(:title) { 'Test Title' }
  
  describe '.get_all' do
    it 'returns all bookmarks' do
      bookmark = Bookmark.add("http://www.makersacademy.com/", 'Makers Academy')
      Bookmark.add("http://www.destroyallsoftware.com/", 'Destroy all software')
      Bookmark.add("http://www.google.com/", 'google')
      
      bookmarks = Bookmark.get_all
      
      expect(bookmarks.length).to eq 3
      expect(bookmarks.first).to be_a Bookmark
      expect(bookmarks.first.id).to eq bookmark.id
      expect(bookmarks.first.title).to eq 'Makers Academy' 
      expect(bookmarks.first.url).to eq 'http://www.makersacademy.com/'
    end
  end

  describe '.add' do
    it 'adds a bookmark to the database' do
      # we setup the .add method to return value from the database
      # we get: {"id"=>"some_id", "url"=>"http://www.youtube.com/", "'Test Title'"} 
      bookmark = Bookmark.add(url, title)
      persisted_data = persisted_data(bookmark.id)
      # expect(Bookmark.get_all).to include({title: title, url: url})
      # we wanna check if the return value from inserting into the database is the same as insterted value
      # expect(bookmark.id).to eq persisted_data('id')
      expect(bookmark.id).to eq persisted_data['id']
      expect(bookmark.title).to eq 'Test Title'
      expect(bookmark.url).to eq 'http://www.youtube.com/'
    end
  end

  describe '.delete' do
    it 'deletes a bookmark' do
      # we check if the bookmark was correctly added to the database
      
      bookmark = Bookmark.add(url, title)
      persisted_data = persisted_data(bookmark.id)

      expect(bookmark.id).to eq persisted_data['id']
      expect(bookmark.title).to eq title
      expect(bookmark.url).to eq url

      # we check if the bookmark is deleted

      deleted_bookmark = Bookmark.delete(bookmark.id)
      persisted_data_for_delete = persisted_data(deleted_bookmark[0]['id'])

      expect(persisted_data_for_delete).to eq nil
      expect(Bookmark.get_all).not_to include bookmark
      expect(Bookmark.get_all.length).to eq 0 

      expect(deleted_bookmark[0]['id']).to eq bookmark.id
      expect(bookmark.title).to eq title
      expect(bookmark.url).to eq url
    end
  end
end
