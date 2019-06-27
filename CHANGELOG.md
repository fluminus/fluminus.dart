## 0.1.1

- Initial version.

## 0.1.2

- Update sample code.

## 0.1.3

- Cache JWT (no expiry check though)
- Update API link

## 0.1.4

- Fixed a serious problem =)

## 0.1.5

- Now all the provided APIs work properly =)

## 0.1.6

- Hide files that are necessary and exported inside `luminus_api.dart`
- Fixed the dependency issue.
- Added documentation for `luminus_api.dart`, which is the entry of this package.
- Implemented automatic management of JWT renewal as long as you stick to the same `Authentication` objected created.

## 0.1.7

- Downgraded dependecy requirement of `meta`
- Removed unnecessary imports.
- Made the package description longer so that pub.dev doesn't complain.

## 0.1.8

<!-- - Provide all GET APIs for announcements. -->
- Maybe LumiNUS internally has a shorter token expiry time, I manually set the `_jwtExpiresIn` as 10 minutes and `_refreshTokenExpiresIn` as an hour. Please send an issue if this doesn't solve your problem.
- Provide exceptions for API call HTTP exceptions (as specified in LumiNUS API documentation).
- Add timeouts for HTTP requests.
- Add methods for enforced re-authentication: `forcedRefresh method in Authorization`.

## 0.1.9

- Overriden `==` for data abstractions to resolve this [issue](https://github.com/fluminus/fluminus_app/issues/27).

## 0.1.10 - 0.1.15

- Support FutureOr<Authentication> as the provided parameter for LumiNUS API methods, so that you can use `SharedPreferences` or `Flutter Secure Storage` with this package.
- Throw `AuthorizationException` when something goes wrong in `_getJwt`
- Added `RestartAuthException` to deal with weird LumiNUS behavior
- Overrode `hashCode` for `File` class

## 0.1.16

- Support for notifictaions