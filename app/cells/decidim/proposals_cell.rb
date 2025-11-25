# frozen_string_literal: true

module Decidim
  class ProposalsCell < Decidim::ViewModel
    include Decidim::CellsPaginateHelper
    include Decidim::Core::Engine.routes.url_helpers
    include Decidim::CardHelper
    include Decidim::Coauthorable

    def show
      render :show
    end

    def proposals
      # @proposals ||= Decidim::Proposals::Proposal.where(component:).joins(:coauthorships)
      #                               .where(decidim_coauthorships: { decidim_author_type: "Decidim::UserBaseEntity" })
      #                               .not_hidden
      #                               .published
      #                               .not_withdrawn
      @proposals ||= Decidim::Proposals::Proposal.joins(:coauthorships)
                        .where("decidim_coauthorships.decidim_user_group_id": user_group.id)
    end

    def memberships
      @memberships ||= case role
                       when "member"
                         Decidim::UserGroups::MemberMemberships.for(model).page(params[:page]).per(20)
                       when "admin"
                         Decidim::UserGroups::AdminMemberships.for(model).page(params[:page]).per(20)
                       else
                         Decidim::UserGroups::AcceptedMemberships.for(model).page(params[:page]).per(20)
                       end
    end

    def role
      options[:role].to_s
    end
  end
end
