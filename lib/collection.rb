module Atom
  module Acts #:nodoc:
    module Collection #:nodoc:
      class UndefinedOptionError < StandardError ; end
      class UnsupportedContentTypeError < StandardError ; end

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_collection(opts = {})
          include Atom::Acts::Collection::InstanceMethods
          extend Atom::Acts::Collection::SingletonMethods
          raise UndefinedOptionError('accept') unless opts.include?:accept
          raise UndefinedOptionError('href') unless opts.include?:href
          raise UndefinedOptionError('title') unless opts.include?:title
          raise UndefinedOptionError('workspace') unless opts.include?:workspace
          accept = [] << opts[:accept]
          opts[:accept] = accept.flatten
          
          if opts[:categories]
            categories_list = [] << opts[:categories]
            opts[:categories] = categories_list.flatten
          end
          @atom_pub_opts = opts
          
          collection_post_method = ENV['COLLECTION_POST_METHOD'] || :create
          entry_put_method = ENV['ENTRY_PUT_METHOD'] || :update
          self.before_filter :filter_content_type, :only => [collection_post_method, entry_put_method]
        end        
      end

      module SingletonMethods
        def acts_as_collection?
          true
        end
        
        def atom_pub_opts
          @atom_pub_opts
        end
      end

      module InstanceMethods
      end
    end
  end
end