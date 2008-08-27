steps_for(:database) do

  Given "$a_or_an $resource_class with $attributes exists" do |a_or_an, resource_class, attributes|
    klass = resource_class.gsub(' ', '_').classify.constantize
    attributes = attributes.to_hash_from_story
    resource = klass.create!(attributes)
    resource.should_not be_nil
    instance_variable_set("@#{resource_class.gsub(" ","_")}", resource)
  end

  Given "no $resource_class with $attributes exists" do |resource_class, attributes|
    klass = resource_class.gsub(' ', '_').classify.constantize
    attributes = attributes.to_hash_from_story
    klass.destroy_all(attributes)
    klass.find_all(attributes).should be_nil
  end

  Then "$a_or_an $resource_class with $attributes should exist" do |a_or_an, resource_class, attributes|
    klass = resource_class.gsub(' ', '_').classify.constantize
    attributes = attributes.to_hash_from_story
    resource = klass.find_first(attributes)
    resource.should_not be_nil
    instance_variable_set("@#{resource_class.gsub(" ","_")}", resource)
  end

  Then "no $resource_class with $attributes should exist" do |resource_class, attributes|
    klass = resource_class.gsub(' ', '_').classify.constantize
    attributes = attributes.to_hash_from_story
    resource = klass.find_first(attributes)
    resource.should be_nil
  end

end