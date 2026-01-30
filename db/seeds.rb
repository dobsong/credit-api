# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ProjectPlan.create(
    user: "default_user",
    title: "Sample Project Plan",
    previous_engagement: "None",
    has_started: false,
    vision: "To create a sample project plan.",
    laymans_summary: "This is a simple summary of the project plan.",
    stakeholder_analysis: "Identify key stakeholders.",
    approach: "Agile methodology.",
    data: "Use existing datasets.",
    ethics: "Ensure compliance with ethical standards.",
    platform: "Web-based platform.",
    support_materials: "Provide documentation and tutorials.",
    costings: "Estimated budget of $10,000."
)
