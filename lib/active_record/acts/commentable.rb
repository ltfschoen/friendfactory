module ActiveRecord
  module Acts
    module Commentable
      def self.included(base)
        base.extend(ClassMethods)
        define_method(:commentable?) { false }
      end

      module ClassMethods
        def acts_as_commentable
          class_eval do
            include ActiveRecord::Acts::Commentable::InstanceMethods

            belongs_to :parent,
                :class_name    => 'Posting::Base',
                :foreign_key   => 'parent_id',
                :counter_cache => :children_count

            has_many :children,
                :class_name  => 'Posting::Base',
                :foreign_key => 'parent_id',
                :dependent   => :destroy,
                :counter_sql => proc {
                    %Q(SELECT COUNT(*) FROM
                      ((SELECT DISTINCT p2.lev2 AS id FROM
                          (SELECT p1.id AS lev1, p2.id AS lev2
                          FROM postings AS p1
                          LEFT JOIN POSTINGS AS p2 ON p2.parent_id = p1.id
                          WHERE p1.id = #{id}) AS p2
                       WHERE lev2 IS NOT NULL)
                      UNION
                      (SELECT DISTINCT p3.lev3 FROM
                          (SELECT p1.id AS lev1, p2.id AS lev2, p3.id AS lev3
                          FROM postings AS p1
                          LEFT JOIN POSTINGS AS p2 ON p2.parent_id = p1.id
                          LEFT JOIN POSTINGS AS p3 ON p3.parent_id = p2.id
                          WHERE p1.id = #{id}) as p3
                       WHERE lev3 IS NOT NULL)) t1) }
                # :after_add => :publish_child_to_parents_waves
          end
        end
      end

      module InstanceMethods
        def commentable?
          true
        end

        def comments
          children.type(Posting::Comment).scoped
        end

        def ancestors
          node, nodes = self, []
          nodes << node = node.parent while node.parent
          nodes
        end

        def root
          node = self
          node = node.parent while node.parent
          node
        end

        def siblings
          self_and_siblings - [self]
        end

        def self_and_siblings
          parent ? parent.children : self.class.roots
        end

        # private

        # def publish_child_to_parents_waves(child)
        #   if root
        #     root.publications.each do |publication|
        #       unless child.publication.wave_ids.include?(publication[:id])
        #         child.publications << publication.clone                
        #       end
        #     end
        #   end
        # end
        
      end
    end
  end
end