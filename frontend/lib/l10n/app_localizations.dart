import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CookMate AI'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AI Recipe'**
  String get welcomeTitle;

  /// No description provided for @welcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover delicious recipes made just for you.'**
  String get welcomeDesc;

  /// No description provided for @aiPoweredTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Powered Recommendations'**
  String get aiPoweredTitle;

  /// No description provided for @aiPoweredDesc.
  ///
  /// In en, this message translates to:
  /// **'Get recipe suggestions based on your taste and ingredients.'**
  String get aiPoweredDesc;

  /// No description provided for @easyCookTitle.
  ///
  /// In en, this message translates to:
  /// **'Easy to Cook Delicious to Eat'**
  String get easyCookTitle;

  /// No description provided for @easyCookDesc.
  ///
  /// In en, this message translates to:
  /// **'Step by step recipes with images and tips.'**
  String get easyCookDesc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @recipeDetails.
  ///
  /// In en, this message translates to:
  /// **'Recipe Details'**
  String get recipeDetails;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @startCooking.
  ///
  /// In en, this message translates to:
  /// **'Start Cooking'**
  String get startCooking;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'added to favorites!'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'removed from favorites!'**
  String get removedFromFavorites;

  /// No description provided for @sharing.
  ///
  /// In en, this message translates to:
  /// **'Sharing...'**
  String get sharing;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Cal'**
  String get calories;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @cookingTime.
  ///
  /// In en, this message translates to:
  /// **'Cooking Time'**
  String get cookingTime;

  /// No description provided for @askAiChef.
  ///
  /// In en, this message translates to:
  /// **'Ask AI Chef'**
  String get askAiChef;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search recipes, ingredients...'**
  String get searchPlaceholder;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommendedForYou;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening,'**
  String get goodEvening;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @dessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get dessert;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @errorLoadingRecipes.
  ///
  /// In en, this message translates to:
  /// **'Error loading recipes'**
  String get errorLoadingRecipes;

  /// No description provided for @cookingComplete.
  ///
  /// In en, this message translates to:
  /// **'Cooking Complete! Enjoy your meal! 🎉'**
  String get cookingComplete;

  /// No description provided for @cookingTimerStarted.
  ///
  /// In en, this message translates to:
  /// **'Cooking timer started! Speaking steps...'**
  String get cookingTimerStarted;

  /// No description provided for @timerPaused.
  ///
  /// In en, this message translates to:
  /// **'Timer paused. Audio stopped.'**
  String get timerPaused;

  /// No description provided for @ingredientsRequired.
  ///
  /// In en, this message translates to:
  /// **'Ingredients Required'**
  String get ingredientsRequired;

  /// No description provided for @buyNowInstamart.
  ///
  /// In en, this message translates to:
  /// **'Buy Now on Instamart'**
  String get buyNowInstamart;

  /// No description provided for @couldNotLaunchInstamart.
  ///
  /// In en, this message translates to:
  /// **'Could not launch Instamart'**
  String get couldNotLaunchInstamart;

  /// No description provided for @cookingMode.
  ///
  /// In en, this message translates to:
  /// **'Cooking Mode'**
  String get cookingMode;

  /// No description provided for @listeningForNextStep.
  ///
  /// In en, this message translates to:
  /// **'Listening for \"Next Step\"...'**
  String get listeningForNextStep;

  /// No description provided for @advertisement.
  ///
  /// In en, this message translates to:
  /// **'Advertisement'**
  String get advertisement;

  /// No description provided for @cooking.
  ///
  /// In en, this message translates to:
  /// **'Cooking:'**
  String get cooking;

  /// No description provided for @paneer.
  ///
  /// In en, this message translates to:
  /// **'Paneer'**
  String get paneer;

  /// No description provided for @butter.
  ///
  /// In en, this message translates to:
  /// **'Butter'**
  String get butter;

  /// No description provided for @onion.
  ///
  /// In en, this message translates to:
  /// **'Onion'**
  String get onion;

  /// No description provided for @tomatoPuree.
  ///
  /// In en, this message translates to:
  /// **'Tomato Puree'**
  String get tomatoPuree;

  /// No description provided for @g.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get g;

  /// No description provided for @tbsp.
  ///
  /// In en, this message translates to:
  /// **'tbsp'**
  String get tbsp;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'large'**
  String get large;

  /// No description provided for @cup.
  ///
  /// In en, this message translates to:
  /// **'cup'**
  String get cup;

  /// No description provided for @step1.
  ///
  /// In en, this message translates to:
  /// **'Begin by preparing the base of the rich gravy. Heat a generous amount of butter in a large pan or kadai over medium heat until it melts completely and starts to bubble slightly. Add the finely chopped onions to the pan. Sauté the onions patiently for about 8 to 10 minutes, stirring frequently, until they turn a beautiful deep golden brown color. This slow caramelization is key to the flavor of the dish.'**
  String get step1;

  /// No description provided for @step2.
  ///
  /// In en, this message translates to:
  /// **'Once the onions are perfectly caramelized, it is time to build the aromatics. Add the freshly ground ginger-garlic paste into the pan. Stir it continuously and sauté for another one to two minutes until the raw, pungent smell of the garlic completely disappears and a fragrant aroma fills your kitchen.'**
  String get step2;

  /// No description provided for @step3.
  ///
  /// In en, this message translates to:
  /// **'Now, stir in the smooth tomato puree along with the ground spices: turmeric powder, red chili powder, and coriander powder. Mix everything very well. Allow this masala mixture to cook down slowly over medium-low heat. Keep stirring occasionally to prevent burning. Cook until the mixture thickens significantly and you can clearly see the oil separating and leaving the sides of the pan. This indicates the spices are fully cooked.'**
  String get step3;

  /// No description provided for @step4.
  ///
  /// In en, this message translates to:
  /// **'With the masala base ready, gently add the soft paneer cubes into the pan. Be very careful while mixing so that the paneer cubes do not break. Toss them lightly so they are evenly coated with the thick, flavorful masala on all sides. Let the paneer absorb the flavors for about 2 minutes on low heat.'**
  String get step4;

  /// No description provided for @step5.
  ///
  /// In en, this message translates to:
  /// **'Finally, for that signature restaurant-style richness, pour in the heavy cream and gently stir it through the gravy. Sprinkle a pinch of garam masala and crush some roasted kasuri methi (dried fenugreek leaves) between your palms before adding it to the pan. Simmer the entire mixture for another 5 minutes on low heat. Garnish with a little more cream and serve hot with butter naan or jeera rice. Enjoy!'**
  String get step5;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
