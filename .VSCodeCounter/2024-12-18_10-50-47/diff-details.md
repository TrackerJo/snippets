# Diff Details

Date : 2024-12-18 10:50:47

Directory /Volumes/XcodeDev/Downloads/snippets/lib

Total : 55 files,  11460 codes, 797 comments, 778 blanks, all 13035 lines

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [lib/constants.dart](/lib/constants.dart) | Dart | 508 | 3 | 53 | 564 |
| [lib/firebase_options.dart](/lib/firebase_options.dart) | Dart | 59 | 12 | 5 | 76 |
| [lib/helper/app_badge.dart](/lib/helper/app_badge.dart) | Dart | 29 | 0 | 4 | 33 |
| [lib/helper/app_icon_changer.dart](/lib/helper/app_icon_changer.dart) | Dart | 27 | 20 | 7 | 54 |
| [lib/helper/helper_function.dart](/lib/helper/helper_function.dart) | Dart | 198 | 6 | 45 | 249 |
| [lib/main.dart](/lib/main.dart) | Dart | 715 | 149 | 87 | 951 |
| [lib/pages/app_preferences_page.dart](/lib/pages/app_preferences_page.dart) | Dart | 326 | 14 | 10 | 350 |
| [lib/pages/botw_results_page.dart](/lib/pages/botw_results_page.dart) | Dart | 138 | 1 | 9 | 148 |
| [lib/pages/comments_page.dart](/lib/pages/comments_page.dart) | Dart | 0 | 182 | 12 | 194 |
| [lib/pages/create_account_page.dart](/lib/pages/create_account_page.dart) | Dart | 319 | 20 | 15 | 354 |
| [lib/pages/customize_widgets_page.dart](/lib/pages/customize_widgets_page.dart) | Dart | 378 | 1 | 8 | 387 |
| [lib/pages/discussion_page.dart](/lib/pages/discussion_page.dart) | Dart | 470 | 12 | 34 | 516 |
| [lib/pages/discussions_page.dart](/lib/pages/discussions_page.dart) | Dart | 188 | 12 | 20 | 220 |
| [lib/pages/find_profile_page.dart](/lib/pages/find_profile_page.dart) | Dart | 169 | 22 | 13 | 204 |
| [lib/pages/forgot_password_page.dart](/lib/pages/forgot_password_page.dart) | Dart | 197 | 19 | 8 | 224 |
| [lib/pages/friends_page.dart](/lib/pages/friends_page.dart) | Dart | 479 | 14 | 21 | 514 |
| [lib/pages/home_page.dart](/lib/pages/home_page.dart) | Dart | 145 | 71 | 26 | 242 |
| [lib/pages/login_page.dart](/lib/pages/login_page.dart) | Dart | 259 | 19 | 11 | 289 |
| [lib/pages/modify_profile_page.dart](/lib/pages/modify_profile_page.dart) | Dart | 771 | 14 | 15 | 800 |
| [lib/pages/no_wifi_page.dart](/lib/pages/no_wifi_page.dart) | Dart | 101 | 2 | 6 | 109 |
| [lib/pages/notifications_page.dart](/lib/pages/notifications_page.dart) | Dart | 243 | 2 | 10 | 255 |
| [lib/pages/onboarding_page.dart](/lib/pages/onboarding_page.dart) | Dart | 311 | 3 | 16 | 330 |
| [lib/pages/profile_page.dart](/lib/pages/profile_page.dart) | Dart | 872 | 9 | 48 | 929 |
| [lib/pages/question_page.dart](/lib/pages/question_page.dart) | Dart | 200 | 4 | 10 | 214 |
| [lib/pages/responses_page.dart](/lib/pages/responses_page.dart) | Dart | 254 | 5 | 22 | 281 |
| [lib/pages/settings_page.dart](/lib/pages/settings_page.dart) | Dart | 497 | 9 | 12 | 518 |
| [lib/pages/splash_page.dart](/lib/pages/splash_page.dart) | Dart | 15 | 0 | 4 | 19 |
| [lib/pages/swipe_pages.dart](/lib/pages/swipe_pages.dart) | Dart | 346 | 8 | 20 | 374 |
| [lib/pages/update_page.dart](/lib/pages/update_page.dart) | Dart | 95 | 1 | 6 | 102 |
| [lib/pages/voting_page.dart](/lib/pages/voting_page.dart) | Dart | 327 | 10 | 23 | 360 |
| [lib/providers/card_provider.dart](/lib/providers/card_provider.dart) | Dart | 100 | 2 | 28 | 130 |
| [lib/templates/input_decoration.dart](/lib/templates/input_decoration.dart) | Dart | 0 | 0 | 2 | 2 |
| [lib/templates/styling.dart](/lib/templates/styling.dart) | Dart | 302 | 9 | 28 | 339 |
| [lib/widgets/app_icon_tile.dart](/lib/widgets/app_icon_tile.dart) | Dart | 42 | 0 | 3 | 45 |
| [lib/widgets/background_tile.dart](/lib/widgets/background_tile.dart) | Dart | 162 | 23 | 9 | 194 |
| [lib/widgets/botw_result_tile.dart](/lib/widgets/botw_result_tile.dart) | Dart | 111 | 2 | 10 | 123 |
| [lib/widgets/botw_tile.dart](/lib/widgets/botw_tile.dart) | Dart | 173 | 8 | 10 | 191 |
| [lib/widgets/botw_voting_card.dart](/lib/widgets/botw_voting_card.dart) | Dart | 98 | 2 | 10 | 110 |
| [lib/widgets/bullet_list.dart](/lib/widgets/bullet_list.dart) | Dart | 47 | 0 | 4 | 51 |
| [lib/widgets/custom_app_bar.dart](/lib/widgets/custom_app_bar.dart) | Dart | 266 | 14 | 5 | 285 |
| [lib/widgets/custom_nav_bar.dart](/lib/widgets/custom_nav_bar.dart) | Dart | 182 | 1 | 4 | 187 |
| [lib/widgets/custom_page_route.dart](/lib/widgets/custom_page_route.dart) | Dart | 43 | 1 | 5 | 49 |
| [lib/widgets/discussion_tile.dart](/lib/widgets/discussion_tile.dart) | Dart | 107 | 1 | 5 | 113 |
| [lib/widgets/friend_tile.dart](/lib/widgets/friend_tile.dart) | Dart | 140 | 1 | 6 | 147 |
| [lib/widgets/friends_count.dart](/lib/widgets/friends_count.dart) | Dart | 76 | 1 | 4 | 81 |
| [lib/widgets/helper_functions.dart](/lib/widgets/helper_functions.dart) | Dart | 9 | 0 | 4 | 13 |
| [lib/widgets/message_tile.dart](/lib/widgets/message_tile.dart) | Dart | 164 | 11 | 9 | 184 |
| [lib/widgets/notification_tile.dart](/lib/widgets/notification_tile.dart) | Dart | 63 | 0 | 3 | 66 |
| [lib/widgets/profile_tile.dart](/lib/widgets/profile_tile.dart) | Dart | 106 | 1 | 4 | 111 |
| [lib/widgets/quote_tile.dart](/lib/widgets/quote_tile.dart) | Dart | 30 | 0 | 4 | 34 |
| [lib/widgets/response_tile.dart](/lib/widgets/response_tile.dart) | Dart | 192 | 42 | 11 | 245 |
| [lib/widgets/setting_tile.dart](/lib/widgets/setting_tile.dart) | Dart | 57 | 0 | 3 | 60 |
| [lib/widgets/snippet_tile.dart](/lib/widgets/snippet_tile.dart) | Dart | 250 | 33 | 16 | 299 |
| [lib/widgets/snowflake.dart](/lib/widgets/snowflake.dart) | Dart | 61 | 1 | 8 | 70 |
| [lib/widgets/widget_gradient_tile.dart](/lib/widgets/widget_gradient_tile.dart) | Dart | 43 | 0 | 3 | 46 |

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details