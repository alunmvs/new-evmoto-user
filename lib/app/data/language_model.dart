class Language {
  String? onboardingIntroTitle1;
  String? onboardingIntroDescription1;
  String? onboardingIntroTitle2;
  String? onboardingIntroDescription2;
  String? buttonNext;
  String? loginTitle;
  String? loginDescription;
  String? mobilePhone;
  String? loginButton;
  String? loginOr;
  String? termAndCondition;
  String? privacyPolicy;
  String? tncPrivacyConfirmation1;
  String? tncPrivacyConfirmation2;
  String? tncPrivacyConfirmation3;
  String? verificationOtpTitle;
  String? verificationOtpDescription;
  String? verificationOtpNotReceive;
  String? verificationOtpResend;
  String? verificationOtpNotMatch;
  String? homeRideReadyToGoTitle;
  String? homeRideReadyToGoHint;
  String? addLocationHome;
  String? addLocationOffice;
  String? addLocationOther;
  String? discount50;
  String? comingSoon;
  String? delivery;
  String? package;
  String? food;
  String? myBalance;
  String? topup;
  String? history;
  String? seeAll;
  String? promoToday;
  String? home;
  String? activity;
  String? account;
  String? settingLanguage;
  String? settingPayment;
  String? settingSavedLocation;
  String? customerService;
  String? rateUs;
  String? logout;
  String? appVersion;

  Language({
    this.onboardingIntroTitle1,
    this.onboardingIntroDescription1,
    this.onboardingIntroTitle2,
    this.onboardingIntroDescription2,
    this.buttonNext,
    this.loginTitle,
    this.loginDescription,
    this.mobilePhone,
    this.loginButton,
    this.loginOr,
    this.termAndCondition,
    this.privacyPolicy,
    this.tncPrivacyConfirmation1,
    this.tncPrivacyConfirmation2,
    this.tncPrivacyConfirmation3,
    this.verificationOtpTitle,
    this.verificationOtpDescription,
    this.verificationOtpNotReceive,
    this.verificationOtpResend,
    this.verificationOtpNotMatch,
    this.homeRideReadyToGoTitle,
    this.homeRideReadyToGoHint,
    this.addLocationHome,
    this.addLocationOffice,
    this.addLocationOther,
    this.discount50,
    this.comingSoon,
    this.delivery,
    this.package,
    this.food,
    this.myBalance,
    this.topup,
    this.history,
    this.seeAll,
    this.promoToday,
    this.home,
    this.activity,
    this.account,
    this.settingLanguage,
    this.settingPayment,
    this.settingSavedLocation,
    this.customerService,
    this.rateUs,
    this.logout,
    this.appVersion,
  });

  Language.fromJson(Map<String, dynamic> json) {
    onboardingIntroTitle1 = json['onboarding_intro_title_1'];
    onboardingIntroDescription1 = json['onboarding_intro_description_1'];
    onboardingIntroTitle2 = json['onboarding_intro_title_2'];
    onboardingIntroDescription2 = json['onboarding_intro_description_2'];
    buttonNext = json['button_next'];
    loginTitle = json['login_title'];
    loginDescription = json['login_description'];
    mobilePhone = json['mobile_phone'];
    loginButton = json['login_button'];
    loginOr = json['login_or'];
    termAndCondition = json['term_and_condition'];
    privacyPolicy = json['privacy_policy'];
    tncPrivacyConfirmation1 = json['tnc_privacy_confirmation_1'];
    tncPrivacyConfirmation2 = json['tnc_privacy_confirmation_2'];
    tncPrivacyConfirmation3 = json['tnc_privacy_confirmation_3'];
    verificationOtpTitle = json['verification_otp_title'];
    verificationOtpDescription = json['verification_otp_description'];
    verificationOtpNotReceive = json['verification_otp_not_receive'];
    verificationOtpResend = json['verification_otp_resend'];
    verificationOtpNotMatch = json['verification_otp_not_match'];
    homeRideReadyToGoTitle = json['home_ride_ready_to_go_title'];
    homeRideReadyToGoHint = json['home_ride_ready_to_go_hint'];
    addLocationHome = json['add_location_home'];
    addLocationOffice = json['add_location_office'];
    addLocationOther = json['add_location_other'];
    discount50 = json['discount_50'];
    comingSoon = json['coming_soon'];
    delivery = json['delivery'];
    package = json['package'];
    food = json['food'];
    myBalance = json['my_balance'];
    topup = json['topup'];
    history = json['history'];
    seeAll = json['see_all'];
    promoToday = json['promo_today'];
    home = json['home'];
    activity = json['activity'];
    account = json['account'];
    settingLanguage = json['setting_language'];
    settingPayment = json['setting_payment'];
    settingSavedLocation = json['setting_saved_location'];
    customerService = json['customer_service'];
    rateUs = json['rate_us'];
    logout = json['logout'];
    appVersion = json['app_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['onboarding_intro_title_1'] = this.onboardingIntroTitle1;
    data['onboarding_intro_description_1'] = this.onboardingIntroDescription1;
    data['onboarding_intro_title_2'] = this.onboardingIntroTitle2;
    data['onboarding_intro_description_2'] = this.onboardingIntroDescription2;
    data['button_next'] = this.buttonNext;
    data['login_title'] = this.loginTitle;
    data['login_description'] = this.loginDescription;
    data['mobile_phone'] = this.mobilePhone;
    data['login_button'] = this.loginButton;
    data['login_or'] = this.loginOr;
    data['term_and_condition'] = this.termAndCondition;
    data['privacy_policy'] = this.privacyPolicy;
    data['tnc_privacy_confirmation_1'] = this.tncPrivacyConfirmation1;
    data['tnc_privacy_confirmation_2'] = this.tncPrivacyConfirmation2;
    data['tnc_privacy_confirmation_3'] = this.tncPrivacyConfirmation3;
    data['verification_otp_title'] = this.verificationOtpTitle;
    data['verification_otp_description'] = this.verificationOtpDescription;
    data['verification_otp_not_receive'] = this.verificationOtpNotReceive;
    data['verification_otp_resend'] = this.verificationOtpResend;
    data['verification_otp_not_match'] = this.verificationOtpNotMatch;
    data['home_ride_ready_to_go_title'] = this.homeRideReadyToGoTitle;
    data['home_ride_ready_to_go_hint'] = this.homeRideReadyToGoHint;
    data['add_location_home'] = this.addLocationHome;
    data['add_location_office'] = this.addLocationOffice;
    data['add_location_other'] = this.addLocationOther;
    data['discount_50'] = this.discount50;
    data['coming_soon'] = this.comingSoon;
    data['delivery'] = this.delivery;
    data['package'] = this.package;
    data['food'] = this.food;
    data['my_balance'] = this.myBalance;
    data['topup'] = this.topup;
    data['history'] = this.history;
    data['see_all'] = this.seeAll;
    data['promo_today'] = this.promoToday;
    data['home'] = this.home;
    data['activity'] = this.activity;
    data['account'] = this.account;
    data['setting_language'] = this.settingLanguage;
    data['setting_payment'] = this.settingPayment;
    data['setting_saved_location'] = this.settingSavedLocation;
    data['customer_service'] = this.customerService;
    data['rate_us'] = this.rateUs;
    data['logout'] = this.logout;
    data['app_version'] = this.appVersion;
    return data;
  }
}
