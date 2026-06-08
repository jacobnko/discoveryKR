platform :ios, '16.0'

target 'discoverKR' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Suppress all third-party pod warnings (nanopb, GoogleUtilities, PromisesObjC etc.)
  inhibit_all_warnings!

  # v11.x: includes Apple privacy manifests + keeps GAD* API (no code changes).
  # (v12+ renamed the API and would break BannerAd.swift.)
  pod 'Google-Mobile-Ads-SDK', '~> 11.0'
  # Pods for discoverKR

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      # Fix: rsync sandbox deny error (Xcode 15+ build sandboxing)
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      # Fix: double-quoted include warnings (nanopb, GoogleUtilities, PromisesObjC)
      config.build_settings['GCC_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
      # Fix: disable module verifier to suppress FBLPromises/PromisesObjC warnings
      config.build_settings['ENABLE_MODULE_VERIFIER'] = 'NO'
    end
  end
  # Also apply to generated projects (CocoaPods 1.13+)
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
        config.build_settings['GCC_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
        config.build_settings['ENABLE_MODULE_VERIFIER'] = 'NO'
      end
      # Fix: PromisesObjC "Create Symlinks" script phase warning
      target.build_phases.each do |phase|
        if phase.respond_to?(:name) && phase.name == 'Create Symlinks to Header Folders'
          phase.always_out_of_date = '1'
        end
      end
    end
  end

  # Fix: GoogleUtilities double-quoted includes in framework headers → angle brackets
  pods_root = installer.sandbox.root.to_s
  require 'find'
  gu_public_dir = "#{pods_root}/GoogleUtilities/GoogleUtilities"
  if Dir.exist?(gu_public_dir)
    Find.find(gu_public_dir) do |path|
      next unless path.end_with?('.h') && path.include?('/Public/')
      File.chmod(0644, path)
      content = File.read(path)
      fixed = content.gsub(/#(import|include) "([^"]+\.h)"/) do
        "##{$1} <GoogleUtilities/#{$2}>"
      end
      File.write(path, fixed) if fixed != content
    end
  end
  gu_umbrella = "#{pods_root}/Target Support Files/GoogleUtilities/GoogleUtilities-umbrella.h"
  if File.exist?(gu_umbrella)
    File.chmod(0644, gu_umbrella)
    content = File.read(gu_umbrella)
    fixed = content.gsub(/#import "([^"]+\.h)"/, '#import <GoogleUtilities/\1>')
    File.write(gu_umbrella, fixed)
  end


  # Note: PromisesObjC headers left as-is (double quotes are internal-only,
  # ENABLE_MODULE_VERIFIER=NO suppresses the warnings without breaking imports)

  # Fix: nanopb double-quoted includes in framework headers → angle brackets
  nanopb_headers = [
    "#{pods_root}/nanopb/pb_common.h",
    "#{pods_root}/nanopb/pb_decode.h",
    "#{pods_root}/nanopb/pb_encode.h"
  ]
  nanopb_headers.each do |path|
    next unless File.exist?(path)
    File.chmod(0644, path)
    content = File.read(path)
    File.write(path, content.gsub('#include "pb.h"', '#include <nanopb/pb.h>'))
  end
  umbrella = "#{pods_root}/Target Support Files/nanopb/nanopb-umbrella.h"
  if File.exist?(umbrella)
    File.chmod(0644, umbrella)
    content = File.read(umbrella)
    content = content.gsub('#import "pb.h"',        '#import <nanopb/pb.h>')
    content = content.gsub('#import "pb_common.h"', '#import <nanopb/pb_common.h>')
    content = content.gsub('#import "pb_decode.h"', '#import <nanopb/pb_decode.h>')
    content = content.gsub('#import "pb_encode.h"', '#import <nanopb/pb_encode.h>')
    File.write(umbrella, content)
  end
end
