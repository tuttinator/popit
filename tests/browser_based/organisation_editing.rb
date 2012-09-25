# encoding: UTF-8
# coding: UTF-8
# -*- coding: UTF-8 -*-

require 'lib/popit_watir_test_case'
require 'lib/in_place_editing_checks'
require 'lib/entity_create_and_delete'

require 'pry'
require 'net/http'
require 'uri'


class OrganisationEditingTests < PopItWatirTestCase

  include InPlaceEditingChecks
  include EntityCreateAndDelete

  def test_organisation_deleting
    goto_instance 'test'
    delete_instance_database
    load_test_fixture
    login_as_instance_owner    

    # goto bush and check he is there
    goto '/organisation/united-states-government'    
    
    check_delete_entity(
      :delete_link_text => '- delete this organisation',
      :form_name        => 'remove-organisation',
    )

  end

  def test_organisation_editing
    goto_instance 'test'
    delete_instance_database
    load_test_fixture
    goto '/organisation/united-states-government'    

    check_editing_summary

    check_editing_name
  end

  def test_organisation_creation
    goto_instance 'test'
    delete_instance_database
    load_test_fixture
    goto '/organisation'

    def add_organisation_link
      @b.link(:text, '+ Add a new organisation')
    end

    # check that the create new organisation link is not shown. But that it is if the
    # user hovers over the sign in link
    assert ! add_organisation_link.present?
    @b.link(:text, 'Sign In').hover

    assert add_organisation_link.present?

    # login and check link is visible
    login_as_instance_owner
    goto '/organisation'
    assert @b.link(:text, '+ Add a new organisation').present?

    # click on the create new organisation link and check that the form has popped up    
    assert ! @b.form(:name, 'create-new-organisation').present?
    add_organisation_link.click
    @b.form(:name, 'create-new-organisation').wait_until_present

    # try to enter an empty name
    @b.input(:value, "Create new organisation").click
    assert_equal 'Required', @b.div(:class, 'bbf-help').text
    
    # enter a proper name, get sent to organisation page
    @b.text_field(:name, 'name').set "Acme Inc"
    assert_equal "acme-inc", @b.text_field(:name, 'slug').value

    @b.input(:value, "Create new organisation").click
    @b.wait_until { @b.title != 'Organisations' }
    assert_equal "Acme Inc", @b.title
    assert_match /\/acme-inc$/, @b.url
    
    # check that this organisation is in the list of organisations too
    @b.back
    @b.refresh
    @b.li(:text, "Acme Inc").link.click
    assert_equal "Acme Inc", @b.title    
    
    # enter organisation check for no suggestions
    @b.back
    @b.refresh
    add_organisation_link.click
    @b.text_field(:name, 'name').set "I'm a unique name"
    assert_equal 'No matches', @b.ul(:class, 'suggestions').li.text

    # enter dup name and check for suggestions
    @b.refresh
    add_organisation_link.click
    @b.text_field(:name, 'name').set "United"

    @b.wait_until { @b.ul(:class, 'suggestions').present? && @b.ul(:class, 'suggestions').li.text['United States Government'] }
    
    # click on a suggestion, check get existing organisation
    @b.ul(:class, 'suggestions').li.link.click
    assert_match /\/united-states-government$/, @b.url
    
    # enter dup, create anyway, check for new organisation
    @b.back
    add_organisation_link.click
    @b.text_field(:name, 'name').set "United States Government"
    @b.input(:value, "Create new organisation").click
    @b.wait_until { @b.title != 'Organisations' }
    assert_match /\/united-states-government-1$/, @b.url
    
    # enter name that can't be slugged
    @b.back
    add_organisation_link.click
    @b.text_field(:name, 'name').set "网页"
    assert_equal "", @b.text_field(:name, 'slug').value
    @b.input(:value, "Create new organisation").click
    assert_equal 'Required', @b.div(:class =>'bbf-help', :index => 1 ).text
    @b.text_field(:name, 'slug').set 'chinese-name'
    @b.input(:value, "Create new organisation").click
    @b.wait_until { @b.title != 'Organisations' }
    assert_equal "网页", @b.title
    assert_match /\/chinese-name$/, @b.url

  end

end
