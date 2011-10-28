require File.expand_path("../all", File.dirname(__FILE__))

module Jax
  module Generators
    class MaterialGenerator < Jax::Generators::NamedBase
      class_option :append, :default => false, :type => :boolean,
                   :desc => "if it already exists, append shaders to the end of this material"
      class_option :skip_lighting, :default => false, :type => :boolean,
                   :desc => "do not add the 'Lighting' shader to this material"
      
      def initialize(args = [], options = [], config = {})
        if args.length > 1
          super([args.shift], options, config)
          @shaders = args
        else
          super
          @shaders = []
        end
      end
      
      def prepend_lighting_shader
        @shaders.unshift 'lighting' unless options[:skip_lighting] or shader_selected?('lighting')
      end
      
      def create_resource_file
        template 'material.resource.erb', relative_path unless options[:append] and File.file?(absolute_path)
      end
      
      def append_shaders
        # first line of array is just array header stuff, we can do without it
        options = shader_options.to_yaml.lines.to_a[1..-1].collect { |line| "  "+line }.join
        append_file relative_path, options
      end
      
      protected
      # tries to find the asset with the given path, returning nil if an error is encountered.
      def try_find_asset(*path)
        ::Rails.application.assets[File.join *path]
      rescue Sprockets::FileOutsidePaths
        return nil
      end
      
      def shader_options
        shaders.collect do |shader|
          asset = try_find_asset("shaders", shader.underscore, "fragment.glsl") ||
                  try_find_asset("shaders", shader.underscore, "vertex.glsl")
                  
          raise ArgumentError, "Couldn't find #{File.join 'shaders', shader.underscore}" unless asset
          
          options = { 'type' => shader.camelize }
          if manifest = try_find_asset("shaders", shader.underscore, "manifest.yml")
            options.merge!((YAML::load(manifest.to_s) || {})['options'] || {})
          end
          
          options
        end
      end
      
      def shader_selected?(name)
        !shaders.select { |shader| shader.underscore == name.underscore }.empty?
      end
      
      def shaders
        @shaders
      end
      
      def absolute_path
        File.expand_path relative_path, destination_root
      end
      
      def relative_path
        File.join material_path, file_name
      end
      
      def material_path
        File.join "app", "assets", "jax", "resources", "materials"
      end
      
      def file_name
        super + ".resource"
      end
    end
  end
end