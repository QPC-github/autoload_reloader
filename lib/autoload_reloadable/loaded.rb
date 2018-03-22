# frozen_string_literal: true

module AutoloadReloadable
  module Loaded
    AutoloadReloadable.private_constant :Loaded

    class << self
      attr_accessor :reloadable
    end
    self.reloadable = []

    def self.add_reloadable(constant_reference)
      reloadable << constant_reference
    end

    def self.unload_all
      $LOADED_FEATURES.each do |feature|
        Autoloads.loaded(feature)
      end

      unloaded_features = Set.new
      reloadable.each do |ref|
        ref.parent.send(:remove_const, ref.name)
        unloaded_features << ref.filename
      end
      $LOADED_FEATURES.reject! do |feature|
        unloaded_features.include?(feature)
      end
      reloadable.clear
      nil
    end
  end
end
