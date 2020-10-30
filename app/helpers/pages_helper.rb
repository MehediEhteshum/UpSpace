module PagesHelper
    def has_hero_banner()
        current_page?(root_path)
    end
end
