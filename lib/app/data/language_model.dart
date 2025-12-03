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
    return data;
  }
}
