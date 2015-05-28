module Janky
  module Notifier
    class ChatService
      def self.completed(build)
        status = build.green? ? "succeeded :thumbsup:" : "failed :collision::collision::collision::fire::fire::fire:"
        color = build.green? ? "green" : "red"

        message = "Build #%s of `%s/%s@%s` %s (took %ss). %s" % [
          build.number,
          build.repo_name,
          build.branch_name,
          build.short_sha1,
          status,
          build.duration,
          build.web_url
        ]

        ::Janky::ChatService.speak(message, build.room_id, {:color => color, :build => build})
      end
    end
  end
end
