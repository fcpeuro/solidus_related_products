# frozen_string_literal: true

module Spree
  module Api
    class RelationsController < Spree::Api::BaseController
      include Spree::RelatedToFinder

      before_action :load_data, only: [:index, :show, :create, :update, :destroy]
      before_action :find_relation, only: [:show, :update, :destroy]

      def index
        authorize! :index, Relation
        @relations = paginate(@product.relations.accessible_by(current_ability))
        respond_with(@relations)
      end

      def show
        authorize! :show, @relation
        respond_with(@relation)
      end

      def create
        authorize! :create, Relation
        @relation = @product.relations.new(relation_params)
        @relation.relatable = @product
        @relation.related_to = find_related_to

        if @relation.save
          respond_with(@relation, status: 201, default_template: :show)
        else
          invalid_resource!(@relation)
        end
      end

      def update
        authorize! :update, Relation
        if @relation.update(relation_params)
          respond_with(@relation, status: 200, default_template: :show)
        else
          invalid_resource!(@relation)
        end
      end

      def update_positions
        authorize! :update, Relation
        params[:positions].each do |id, index|
          model_class.where(id: id).update_all(position: index)
        end

        respond_to do |format|
          format.json { head :ok }
          format.js { render text: 'Ok' }
        end
      end

      def destroy
        authorize! :destroy, Relation
        @relation.destroy
        respond_with(@relation, status: 204)
      end

      private

      def relation_params
        params.require(:relation).permit(
          :related_to, :relation_type, :relatable, :related_to_id,
          :discount_amount, :description, :relation_type_id,
          :related_to_type, :position
        )
      end

      def load_data
        @product = Spree::Product.friendly.find(params[:product_id])
      end

      # Scope the finder through the parent product so a relation under a
      # different product 404s instead of leaking across context. The :show
      # ability level filters records the user can't read; write actions layer
      # their own authorize! on top.
      def find_relation
        @relation = @product.relations.accessible_by(current_ability, :show).find(params[:id])
      end

      def model_class
        Spree::Relation
      end
    end
  end
end
