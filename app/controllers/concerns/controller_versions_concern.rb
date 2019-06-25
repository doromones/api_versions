module ControllerVersionsConcern
  extend ActiveSupport::Concern

  def api_method(method_name)
    method_name.yield_self(&:to_sym)

    proc = self.class
               .api_versions
               .fetch(api_version, {})
               .fetch(method_name, nil)

    if proc.nil? && api_version != :base
      proc = self.class
                 .api_versions
                 .fetch(:base, {})
                 .fetch(method_name, nil)
    end

    unless proc
      raise NotImplementedError, "please define method `#{method_name}` for version `#{api_version}`"
    end

    proc
  end

  def api_version
    params[:api_version]&.to_sym || :base
  end

  class_methods do
    attr_reader :api_versions

    def api_version(version, method_name, &block)
      @api_versions ||= {}
      @api_versions[version.to_sym] ||= {}
      @api_versions[version.to_sym][method_name] = block

      unless respond_to? method_name
        define_method(method_name) do
          proc = api_method(method_name)
          instance_exec(&proc) if proc
        end
      end
    end
  end
end