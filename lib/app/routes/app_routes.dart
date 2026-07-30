part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const ONBOARDING = _Paths.ONBOARDING;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const HOME = _Paths.HOME;
  static const CATEGORY = _Paths.CATEGORY;
  static const CART = _Paths.CART;
  static const ORDER = _Paths.ORDER;
  static const WISHLIST = _Paths.WISHLIST;
  static const ADDRESS = _Paths.ADDRESS;
  static const ABOUT = _Paths.ABOUT;
  static const SETTING = _Paths.SETTING;
  static const PROFILE = _Paths.PROFILE;
  static const DETAIL_PRODUCT = _Paths.DETAIL_PRODUCT;
  static const CHECKOUT = _Paths.CHECKOUT;
  static const UPLOAD_PAYMENT = _Paths.UPLOAD_PAYMENT;
  static const SUCCESS = _Paths.SUCCESS;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
}

abstract class _Paths {
  _Paths._();
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const CATEGORY = '/category';
  static const CART = '/cart';
  static const ORDER = '/order';
  static const WISHLIST = '/wishlist';
  static const ADDRESS = '/address';
  static const ABOUT = '/about';
  static const SETTING = '/setting';
  static const PROFILE = '/profile';
  static const DETAIL_PRODUCT = '/detail-product';
  static const CHECKOUT = '/checkout';
  static const UPLOAD_PAYMENT = '/upload-payment';
  static const SUCCESS = '/success';
  static const EDIT_PROFILE = '/edit-profile';
}
