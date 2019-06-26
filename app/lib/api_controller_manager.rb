module ApiControllerManager

  def self.included(base)
    base.include(InstanceMethods)
    base.extend(ClassMethods)
  end

  class ApiStructDSL
    attr_reader :methods

    def initialize(version)
      @version = version
      @methods = {}
    end

    def api_method(method_name, options = {}, &block)
      @methods[method_name.to_sym] = {
          options: options,
          proc: block
      }
    end
  end

  module InstanceMethods
    def get_api_proc(method_name, api_version: current_api_version)
      self.class.api_versions[api_version][method_name]
    end

    def run_api_proc(method_name)
      proc_hash = get_api_proc(method_name)

      if proc_hash[:options][:from]
        proc_hash = get_api_proc(method_name, api_version: proc_hash[:options][:from].to_sym)
      end

      if proc_hash[:proc]
        instance_eval(&proc_hash[:proc])
      else
        raise NotImplementedError, "method `#{method_name}` not found"
      end
    end

    def current_api_version
      params[:api_version]&.to_sym || :base
    end
  end

  module ClassMethods
    attr_reader :api_versions

    def api_version(version, &block)
      @api_versions ||= {}

      @api_versions[version.to_sym] = ApiStructDSL.new(version).tap do |struct|
        struct.instance_eval(&block)
      end.methods

      virtual_api_methods.each do |method_name|
        next if respond_to? method_name

        define_method(method_name) do
          run_api_proc(method_name.to_sym)
        end
      end
    end

    def virtual_api_methods
      api_versions.values.map(&:keys).flatten.uniq
    end
  end
end
