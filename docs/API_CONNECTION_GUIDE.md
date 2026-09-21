# Connecting the backend API

The whole app already works with local mock data. Screens and controllers do
**not** talk to data directly - they only call the repositories in
`lib/data/repositories/`. To connect the API you only change the inside of
those repositories. No screen needs to change.

## 1. Set up the client (5 minutes)
1. Open `lib/core/constants/api_constants.dart` and set `baseUrl`.
2. Rename the endpoint constants there to match your backend.
3. `DioProvider` (`lib/data/providers/dio_provider.dart`) is already
   registered. It adds the login token to every request and prints logs in
   debug mode.

## 2. Replace the mock code, repository by repository

| Repository | Method | Suggested endpoint |
|---|---|---|
| `AuthRepository` | `login`, `register`, `logout` | `POST /auth/login`, `POST /auth/register` |
| `AuthRepository` | `updateProfile`, `currentUser` | `PUT /me`, `GET /me` |
| `ProductRepository` | `getCategories` | `GET /categories` |
| `ProductRepository` | `getProducts(category, query, flashSaleOnly)` | `GET /products?category=&q=&flash=1` |
| `ProductRepository` | `getProductById` | `GET /products/{id}` |
| `ProductRepository` | `getRelatedProducts` | `GET /products/{id}/related` |
| `ProductRepository` | `getReviews` | `GET /products/{id}/reviews` |
| `OrderRepository` | `load`, `save` | `GET /orders`, `POST /orders` |
| `AddressRepository` | `load`, `save` | `GET /addresses`, `POST/PUT/DELETE /addresses/{id}` |
| `NotificationRepository` | `load`, `save` | `GET /notifications` |
| `CartRepository` | `load`, `save` | keep local, or `GET/PUT /cart` |

Example (products):

```dart
Future<List<ProductModel>> getProducts({...}) async {
  final response = await Get.find<DioProvider>().dio.get(
    ApiConstants.products,
    queryParameters: {'category': category, 'q': query},
  );

  return (response.data['data'] as List)
      .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
      .toList();
}
```

`ProductModel`, `OrderModel`, `AddressModel`, `UserModel`, `NotificationModel`
and `ReviewModel` all have `fromJson` / `toJson`. If your JSON keys are
different, only change those two methods.

## 3. Things to do at the same time
- **Delete** `_simulateNetwork()` and its calls in `ProductRepository`
  (it only exists to show the loading skeletons).
- **Login token:** after a successful login save it with
  `GetStorage().write(StorageKeys.authToken, token)`; on logout remove it.
- **Errors:** catch `DioException` in the controllers and show
  `DioProvider.messageOf(error)` with `CustomSnackbar.error(...)`.
- **Images:** the `image` / `images` fields take normal `https://` URLs.
  `ProductImage` caches them and shows a pink placeholder if one fails.
- **Profile photo upload:** `UserModel.avatar` may hold an image URL - the
  avatar already shows it (`AvatarView`). Add an upload button when the
  backend has an upload endpoint (the `image_picker` package).
- **Payments (bKash / Nagad / card) and social login** need the backend and
  the provider SDKs; the buttons are ready in the UI.
- **Order status:** the app shows Processing / Shipped / Delivered /
  Cancelled from `OrderModel.status`. Refresh it from `GET /orders`.
