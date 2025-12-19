# frozen_string_literal: true

module Decidim
  class ProposalsCell < Decidim::ViewModel
    include Decidim::CellsPaginateHelper
    include Decidim::Core::Engine.routes.url_helpers
    include Decidim::CardHelper
    include Decidim::Proposals::ProposalsHelper
    # include Decidim::Coauthorable

    # see https://github.com/decidim/decidim/blob/release/0.29-stable/decidim-proposals/app/controllers/decidim/proposals/proposals_controller.rb
    def show
      proposals
      @view_mode = "list"
      render :show
    end

    def proposals
      @proposals ||= Decidim::Proposals::Proposal.joins(:coauthorships)
                                    .where(
                                      decidim_coauthorships: { 
                                        # decidim_author_type: "Decidim::UserBaseEntity",
                                        decidim_user_group_id: profile_holder.id 
                                      }
                                    )
                                    # .with_type(type_key: "proposal")
                                    .not_hidden
                                    .published
                                    .not_withdrawn
      # @proposals ||= Decidim::Proposals::Proposal.joins(:coauthorships)
      #                   .where("decidim_coauthorships.decidim_user_group_id": user_group.id)
    end
  end
end
