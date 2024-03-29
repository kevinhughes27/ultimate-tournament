# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.

# Precompile additional assets.
Rails.application.config.assets.precompile += [
  'login.css',
  'login.js',
  'brochure.css',
  'brochure.js',
  'internal.css',
  'internal.js',
  'schedule_pdf.css',
]
