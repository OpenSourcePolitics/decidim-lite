# frozen_string_literal: true

# Patch pour corriger la méthode file_type dans Decidim::Attachment
# afin d'afficher le bon type MIME sans les query params AWS S3.

Rails.logger.info "✅ Patch chargé : Decidim::Attachment#file_type"

Decidim::Attachment.class_eval do
  def file_type
    # Si le fichier est attaché via ActiveStorage
    if file.attached? && file.respond_to?(:blob)
      return file.blob.content_type.split("/").last.upcase rescue "UNKNOWN"
    end

    # Fallback : si la colonne content_type est présente
    if respond_to?(:content_type) && content_type.present?
      return content_type.split("/").last.upcase
    end

    # Sinon on renvoie une valeur neutre
    "UNKNOWN"
  rescue => e
    Rails.logger.warn("[Attachment#file_type patch] #{e.class}: #{e.message}")
    "UNKNOWN"
  end
end
