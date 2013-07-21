module PageRecord

  module Helpers

    ##
    #
    # returns a hash containing the record-type and the id. The id is based on the type. For example when
    # you specify `:team` as the type, it will search for the `@type` instance variable.
    #
    # example:
    #
    # ```ruby
    # <%= form_for(@team, html:form_record_for(:team)) do |f| %>
    # <% end %>
    # ```
    # this returns the follwing HTML:
    #
    # ```html
    # <form accept-charset="UTF-8" action="/teams/2" class="edit_team" data-team-id="2" id="edit_team_2" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value=""><input name="_method" type="hidden" value="patch"><input name="authenticity_token" type="hidden" value="QXIbPXH65Ek+8i0j2R8akdHX2WXLo2MuDFuUVL8CQpY="></div>
    # </form>
    # ```
    #
    # @param type Symbol identifying the type of record and the variable to use
    # @param var the variable to use. This is optional
    #
    # @return	Hash
    #
    #
    def form_record_for(type, var = nil)
      if var
        id = var.id
      else
        id = instance_eval("@#{type}.id")
      end
      id ||= 'new'
      Hash["data-#{type}-id", id]
    end

    ##
    #
    # returns a string containing the record-type and the id. The id is based on the type. For example when
    # you specify `:team` as the type, it will search for the `type` instance variable.
    #
    # example:
    #
    # ```ruby
    # <tr <%= record_for(:team)%>>
    # ```
    # this returns the follwing HTML:
    #
    # ```html
    # <tr data-team-id="2">
    # ```
    #
    # @param type Symbol identifying the type of record and the variable to use
    # @param var the variable to use. This is optional
    #
    # @return   Hash
    #
    #
    def record_for(record, type = nil)
      unless type
        type = record.class.to_s.downcase
      end
      "data-#{type}-id=#{record.id}"
    end

    ##
    #
    # Returns a hash containing the attribute name. This can be used as html options in rails helpers
    #
    # example in a form builder block:
    #
    # ```ruby
    # <%= f.text_field :name, attribute_for(:name) %>
    # ```
    #
    # this returns the follwing HTML:
    #
    # ```html
    # <input data-attribute-for="name" id="team_name" name="team[name]" type="text">
    # ```
    #
    # @param name Symbol or String identifying the name
    #
    # @return	Hash
    #
    #
    def attribute_for(name)
      Hash['data-attribute-for', name]
    end

    ##
    #
    # Returns a hash containing the action name. This can be used as html options in rails helpers
    #
    # example in a form builder block:
    #
    # ```ruby
    # <%= f.submit "Submit", action_for(:save)%>
    # ```
    #
    # this returns the follwing HTML:
    #
    # ```html
    # <input data-action-for="submit" name="commit" type="submit" value="Submit">
    # ```
    #
    # @param name Symbol or String identifying the action name
    #
    # @return	Hash
    #
    #
    def action_for(name)
      Hash['data-action-for', name]
    end

    ##
    #
    # Writes a tag containing the specified PageRecord attribute
    #
    # example:
    #
    # ```ruby
    #    <% @teams.each do |team| %>
    #      <tr>
    #        <%= attribute_tag_for(:td, :name) { team.name} %>
    #        <%= attribute_tag_for(:td, :competition) { team.competition} %>
    #        <%= attribute_tag_for(:td, :point) { team.point} %>
    #        <%= attribute_tag_for(:td, :ranking) { team.ranking} %>
    #        <td><%= link_to 'Show', team, action_for(:show) %></td>
    #        <td><%= link_to 'Edit', edit_team_path(team), action_for(:edit) %></td>
    #        <td><%= link_to 'Destroy', team, {method: :delete, data: { confirm: 'Are you sure?' }}.merge(action_for(:destroy)) %></td>
    #      </tr>
    # ```
    #
    # the first `attribute_tag_for` lines returns the follwing HTML:
    #
    # ```html
    # <td data-attribute-for="name">aa</td>
    # ```
    #
    #
    # rubocop:disable ParameterLists
    def attribute_tag_for(name, attribute, content_or_options_with_block = nil, options = nil, escape = true, &block)
      options ||= options ? options << { 'data-attribute-for' => attribute } : { 'data-attribute-for' => attribute }
      if block_given?
        options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
        content_tag_string(name, capture(&block), options, escape)
      else
        content_tag_string(name, content_or_options_with_block, options, escape)
      end
    end
    # rubocop:enable ParameterLists

    alias_method :atf, :attribute_tag_for

    ##
    #
    # build a form that automagicaly identifies a form as a PageRecord recognisable form
    # The form is identified by the id of the given record or `new` if the record is new.
    #
    # All the elements in the form are labeled according to there field name. And thus easy
    # recognisable by PageRecord
    #
    # example:
    #
    # ```ruby
    # <%= record_form_for(@team) do |f| %>
    #  <div class="field" >
    #    <%= f.label :name %><br>
    #    <%= f.text_field :name %>
    #  </div>
    #  <div class="field"%>
    #    <%= f.label :competition %><br>
    #    <%= f.text_field :competition%>
    #  </div>
    #  <div class="actions">
    #   <%= f.submit "Submit"%>
    #  </div>
    # <% end %>
    # ```
    # @see
    #
    # @return	formBuilder object
    #
    #
    def record_form_for(record, options = {}, &block)
      case record
      when String, Symbol
        object_name = record
      else
        object      = record.is_a?(Array) ? record.last : record
        raise ArgumentError, 'First argument in form cannot contain nil or be empty' unless object
        object_name = options[:as] || model_name_from_record_or_class(object).param_key
      end
      options = options.merge(html: form_record_for(object_name), builder: PageRecord::FormBuilder)
      form_for(record, options, &block)
    end
  end

end

# rubocop:disable HandleExceptions
begin
  ActionView::Base.send :include, PageRecord::Helpers
rescue NameError
end
# rubocop:enable HandleExceptions
