class GeonamesModelsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      %w(country city).each do |model_name|
        m.file "models/#{model_name}.rb", "app/models/#{model_name}.rb"
      end
    end
  end
end