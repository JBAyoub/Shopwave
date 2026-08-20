## Screenshots
<img width="444" height="957" alt="9" src="https://github.com/user-attachments/assets/da1fccce-d8b1-47e0-bc4d-3ad4cc15f22c" />
<img width="423" height="931" alt="8" src="https://github.com/user-attachments/assets/17f229ca-4352-4502-89d3-f01e92bf269a" />
<img width="422" height="942" alt="7" src="https://github.com/user-attachments/assets/eef1530b-fb75-4c22-a5f8-6a469bf3e169" />
<img width="434" height="952" alt="6" src="https://github.com/user-attachments/assets/46cb524b-3538-41cd-836d-eeff539b4539" />
<img width="432" height="955" alt="5" src="https://github.com/user-attachments/assets/b8e3998a-d818-41a2-90d8-ffe0daedf631" />
<img width="407" height="928" alt="4" src="https://github.com/user-attachments/assets/117e204a-3208-4dc7-b183-03bc7d0d8e4d" />
<img width="427" height="938" alt="3" src="https://github.com/user-attachments/assets/e7a0d662-95f8-42dd-b7ba-c62f9224a222" />
<img width="410" height="933" alt="2" src="https://github.com/user-attachments/assets/c448545b-3e8f-4b26-88f6-5e5377004e2d" />
<img width="416" height="933" alt="1" src="https://github.com/user-attachments/assets/8eda2254-aa37-4137-8073-d35a34e77a48" />


## Project overview

ShopWave consists of two applications:

- Flutter mobile client
- Serverpod backend backed by PostgreSQL

The Flutter client communicates with the backend over HTTP using Dio. Serverpod handles authentication, REST endpoints, database access, and PostgreSQL persistence.

The application currently supports:

- User login and session restoration
- JWT authentication
- Authenticated API requests
- Protected routes
- Product listing
- Product detail pages
- Remote product images
- Image caching and loading/error placeholders
- Add-to-cart functionality
- Cart quantity management
- Cart item removal
- Cart total calculation
- Cart item-count calculation
- Checkout summary
- Order creation
- Order history
- Order status presentation
- Pull-to-refresh for products
- Loading, error, and data states using `AsyncValue`
- Reactive navigation after successful order creation
- PostgreSQL persistence through Serverpod
- Serverpod email authentication
- Linking Serverpod authentication users to application users

---

# Architecture

## Feature-first architecture

The Flutter application is organized by feature instead of grouping every widget, provider, and screen into global folders.

```text
showave/
├── lib/
│   ├── core/
│   │   ├── constants.dart
│   │   └── dio_client.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── auth_provider.dart
│   │   │   ├── auth_state.dart
│   │   │   ├── login_screen.dart
│   │   │   └── widgets/
│   │   │
│   │   ├── cart/
│   │   │   ├── cart_provider.dart
│   │   │   └── cart_screen.dart
│   │   │
│   │   ├── orders/
│   │   │   ├── checkout_screen.dart
│   │   │   ├── order_history_screen.dart
│   │   │   ├── order_provider.dart
│   │   │   ├── order_success_screen.dart
│   │   │   └── order_summary_provider.dart
│   │   │
│   │   ├── product/
│   │   │   ├── product_provider.dart
│   │   │   ├── product_details_provider.dart
│   │   │   ├── products_screen.dart
│   │   │   ├── product_detail_screen.dart
│   │   │   └── widgets/
│   │   │
│   │   ├── profile/
│   │   │   ├── profile_provider.dart
│   │   │   └── profile_screen.dart
│   │   │
│   │   └── home/
│   │
│   ├── models/
│   │   ├── cart_item.dart
│   │   ├── order.dart
│   │   ├── product.dart
│   │   └── user.dart
│   │
│   ├── router.dart
│   └── main.dart
│
└── pubspec.yaml
```

This structure keeps the code related to a particular business feature close together.

For example, everything related to authentication lives under:

```text
features/auth/
```

while everything related to products lives under:

```text
features/product/
```

The `core` directory contains application-wide infrastructure such as networking configuration and constants.

The `models` directory contains domain/data models shared between features.

---

# State management with Riverpod

Riverpod is the main state-management mechanism in the Flutter client.

The project uses several Riverpod provider types depending on the problem being solved.

## Synchronous state

The cart is local synchronous application state.

```dart
final cartProvider =
    NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);
```

`CartNotifier` owns the cart state and exposes operations such as:

- `addItem`
- `removeItem`
- `updateQuantity`
- `clear`

This keeps mutations out of the UI.

The UI reads the state:

```dart
ref.watch(cartProvider);
```

and invokes commands through:

```dart
ref.read(cartProvider.notifier).addItem(product);
```

---

## Asynchronous state

Remote data is represented using `AsyncNotifier`.

For example, products are loaded through:

```dart
final productsProvider =
    AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);
```

The provider exposes the three important states of an asynchronous operation:

```text
loading
data
error
```

The UI handles them with:

```dart
productsState.when(
  loading: ...,
  data: ...,
  error: ...,
);
```

The same pattern is used for orders.

This avoids manually maintaining separate:

```text
isLoading
data
error
```

variables throughout the UI.

---

## Derived state

The cart also demonstrates derived providers.

The application derives the total number of items:

```dart
final cartCounterProvider = Provider<int>((ref) {
  return ref.watch(
    cartProvider.select(
      (items) => items.fold(
        0,
        (sum, item) => sum + item.quantity,
      ),
    ),
  );
});
```

The cart total is derived separately:

```dart
final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);

  return items.fold(
    0.0,
    (total, item) => total + item.subtotal,
  );
});
```

This demonstrates an important distinction in Riverpod:

```text
Source state
     |
     +---- derived value
     |
     +---- another derived value
     |
     +---- UI
```

The cart itself remains the source of truth.

---

## Fine-grained subscriptions with select

The cart-count badge does not need the entire cart for its purpose.

Instead it selects the value it actually cares about:

```dart
ref.watch(
  cartProvider.select(
    (items) => items.fold(
      0,
      (sum, item) => sum + item.quantity,
    ),
  ),
);
```

This is useful when a widget only depends on a small projection of a larger state object.

---

## Parameterized providers

Product details use a parameterized provider:

```dart
final productProvider =
    FutureProvider.autoDispose.family<Product, String>(
  (ref, productId) async {
    ...
  },
);
```

This allows the same provider declaration to represent different products:

```text
productProvider("1")
productProvider("2")
productProvider("42")
```

Each parameter represents an independent provider instance.

This is particularly useful for screens whose data depends on a route parameter.

For example:

```text
/product/1
/product/42
/product/100
```

can all use the same provider definition.

---

## Provider lifecycle

Product detail providers use `autoDispose` because product detail data is tied to the screen that requested it.

When no part of the application is using that provider anymore, Riverpod can dispose of its state.

This prevents parameterized detail providers from accumulating indefinitely.

---

# Authentication

Authentication is implemented using Serverpod's authentication infrastructure with email/password authentication.

The flow is:

```text
Flutter
   |
   | POST /login
   | email + password
   v
Serverpod LoginRoute
   |
   v
Serverpod Email IDP
   |
   | credentials validated
   v
JWT token
   |
   v
Flutter
   |
   | SharedPreferences
   v
Persisted session
```

The token is then attached to authenticated requests.

The application has an authenticated Dio provider that adds:

```http
Authorization: Bearer <JWT>
```

to requests.

---

# Session restoration

On application startup, the authentication provider checks for a previously stored token.

If a token exists, the Flutter application calls:

```text
GET /profile
```

with the token.

The backend validates the JWT and resolves the authenticated Serverpod user.

The application then loads the corresponding application user.

This means the application does not simply assume that a locally stored token is valid.

The server is asked to validate the session.

---

# Authentication user vs application user

ShopWave separates Serverpod authentication data from the application's own user data.

Conceptually:

```text
Serverpod authentication user
        |
        | authUserId
        v
Application User
```

The custom `user` table contains the application's user information while Serverpod's authentication tables contain authentication credentials and authentication state.

The `authUserId` field provides the relationship between the two.

During signup:

```dart
final authUser =
    await AuthServices.instance.authUsers.create(session);
```

The same ID is stored in the application user:

```dart
User(
  name: name,
  email: email,
  authUserId: authUser.id,
)
```

Later, the profile endpoint can resolve the authenticated Serverpod user and query:

```text
user.authUserId == authenticatedUserId
```

This is the bridge between authentication and application data.

---

# HTTP networking

Dio is used as the HTTP client.

The project has:

```text
dioProvider
authenticatedDioProvider
```

The base HTTP client configures:

- Base URL
- Connection timeout
- Receive timeout
- JSON headers
- Development logging

The authenticated client attaches the stored JWT automatically.

The application therefore separates:

```text
unauthenticated requests
```

from:

```text
authenticated requests
```

while keeping the actual HTTP calls inside their relevant feature providers.

---

# Routing

GoRouter handles application navigation.

Routes include:

```text
/login
/products
/product/:id
/cart
/checkout
/order_history
/order-success/:id
/profile
```

The router also implements authentication-aware redirection.

The application uses a `ChangeNotifier` bridge to notify GoRouter when the authentication state changes.

Conceptually:

```text
Riverpod auth state
        |
        v
Auth change notification
        |
        v
GoRouter refresh
        |
        v
redirect decision
```

Unauthenticated users are redirected to `/login`.

Authenticated users attempting to access the login screen are redirected to `/products`.

---

# Products

Products are loaded asynchronously from the backend.

The product list uses:

```text
AsyncNotifier
    |
    +-- loading
    +-- data
    +-- error
```

The product screen displays products in a grid.

Each product contains:

- ID
- Name
- Description
- Price
- Image URL
- Category

Product details are loaded independently using a parameterized provider.

---

# Image loading and caching

Product images are loaded from remote URLs using `cached_network_image`.

The product card provides:

- Fixed image area
- Remote image loading
- Placeholder
- Error widget
- Cached image data

This prevents the UI from depending on the original image dimensions and provides a controlled visual layout.

The image widget also gives the user a meaningful fallback when a remote image cannot be fetched.

---

# Cart

The cart is client-side state managed by a Riverpod `Notifier`.

Supported operations include:

```text
Add item
Remove item
Increase quantity
Decrease/update quantity
Clear cart
```

When adding a product that already exists in the cart, the quantity is increased rather than creating a duplicate cart entry.

Each `CartItem` calculates its own subtotal:

```dart
double get subtotal => product.price * quantity;
```

The cart then derives:

```text
Item count
Cart total
Checkout readiness
Order summary
```

from the cart state.

---

# Checkout

The checkout screen consumes derived state from:

```text
authProvider
cartProvider
cartCounterProvider
cartTotalProvider
```

An `OrderSummary` aggregates the relevant information needed by the checkout screen:

```text
User
Email
Cart items
Total
Item count
```

Checkout is considered ready only when:

```text
authenticated user
+
at least one cart item
```

are present.

---

# Orders

Orders are handled through an asynchronous Riverpod controller.

The order provider:

- Fetches order history
- Creates orders
- Updates its local state after order creation
- Clears the cart after a successful order

The order payload contains:

```text
product ID
product name
quantity
price at purchase
order total
```

The price at purchase is stored with the order item so that historical orders are not dependent on the product's current price.

---

# Order lifecycle

The checkout flow is:

```text
Products
   |
   v
Cart
   |
   v
Checkout
   |
   | POST /orders
   v
Serverpod
   |
   v
PostgreSQL
   |
   v
Created Order
   |
   v
Order Success
   |
   v
Order History
```

The application then navigates to:

```text
/order-success/:id
```

after the order is successfully created.

---

# Pull to refresh

The product list supports pull-to-refresh.

The refresh operation invalidates/reloads the asynchronous provider and waits for the new value before completing the refresh callback.

Conceptually:

```text
User pulls
    |
    v
invalidate provider
    |
    v
new HTTP request
    |
    v
provider reaches data/error
    |
    v
refresh Future completes
```

This is useful because the refresh indicator should remain active until the refresh operation actually finishes.

---

# Error and loading handling

The UI consistently handles asynchronous state using Riverpod's `AsyncValue`.

Typical states are:

```text
AsyncLoading
AsyncData
AsyncError
```

Screens provide dedicated UI for each state.

Examples include:

- Loading indicators
- Retry buttons
- Error messages
- Empty-state handling
- Snackbars
- Navigation after successful operations

---

# Backend

The backend is implemented using Serverpod and PostgreSQL.

The backend exposes custom REST routes for the Flutter client, including:

```text
POST /login
POST /signup
GET  /profile
GET  /products
GET  /products/:id
GET  /orders
POST /orders
```

The backend uses Serverpod's database layer and generated models.

PostgreSQL stores:

```text
Users
Products
Orders
Order items
Serverpod authentication data
```

Serverpod authentication uses its email identity provider.

---

# Backend database

The project uses PostgreSQL running inside Docker.

The development setup used during development maps:

```text
Host:      localhost
Port:      5433
Container: 5432
```

The backend connects to the PostgreSQL database through the Docker mapping.

The Android emulator cannot use the host's `localhost` to reach the Flutter backend. The Flutter development configuration therefore uses:

```text
http://10.0.2.2:8082
```

where `10.0.2.2` represents the host machine from the Android emulator.

---

# Local development requirements

You will need:

- Flutter
- Dart
- Android Studio or another Flutter-compatible IDE
- Android emulator or physical Android device
- Docker Desktop
- PostgreSQL container
- Serverpod CLI
- Git

The Flutter project used during development was running on:

```text
Flutter 3.44.x
Dart 3.12.x
```

The exact versions can be checked with:

```bash
flutter --version
dart --version
```

---

# Repository structure

The intended full repository structure is:

```text
ShopWave/
├── showave/
│   ├── lib/
│   ├── android/
│   ├── ios/
│   ├── pubspec.yaml
│   └── README.md
│
└── shopwave_backend_server/
    ├── lib/
    ├── config/
    ├── migrations/
    ├── docker-compose.yml
    └── pubspec.yaml
```

If the Flutter client and Serverpod backend are placed in separate repositories, adjust the paths accordingly.

---

# Running the PostgreSQL database

Start Docker Desktop first.

From the backend directory:

```bash
docker compose up -d
```

Verify the container:

```bash
docker ps
```

The development PostgreSQL container used by ShopWave is:

```text
password-db
```

The PostgreSQL port mapping is:

```text
5433:5432
```

You can enter the database using:

```bash
docker exec -it password-db psql -U postgres -d shopwave_backend
```

If the database username differs in your local configuration, replace `postgres` with the configured database user.

Once inside PostgreSQL:

```sql
\dt
```

to list tables.

Useful tables include:

```text
user
product
order
order_item
serverpod_auth_core_user
serverpod_auth_idp_email_account
```

---

# Serverpod passwords

The backend requires local Serverpod secrets.

The project uses a local:

```text
config/passwords.yaml
```

Do not commit real credentials to GitHub.

The password configuration must contain the values required by the backend configuration, including the database password and the Serverpod authentication/service secrets used by the project.

If the project is cloned without this file, create the local configuration using the project's Serverpod configuration and provide your own development secrets.

Never publish:

```text
database passwords
JWT secrets
service secrets
authentication peppers
API keys
private credentials
```

If environment variables are used instead, the database password can be supplied through the corresponding Serverpod environment variable, for example:

```bash
SERVERPOD_PASSWORD_database=your_database_password
```

The exact password keys should match the backend's `passwords.yaml` and Serverpod configuration.

---

# Database migrations

After changing Serverpod database models, regenerate the Serverpod code and apply the required migration.

Typical development commands are:

```bash
serverpod generate
```

Then use the migration workflow configured by the backend.

Do not assume that changing a Serverpod model automatically changes an already-running PostgreSQL database.

A generated model and the actual database schema must remain synchronized.

For example, if the `User` model gains:

```text
authUserId
```

the PostgreSQL `user` table must also contain the corresponding column.

---

# Creating a test account

The recommended way to create a login-compatible user is through the application's signup endpoint rather than inserting authentication rows manually.

Example request:

```bash
curl -X POST http://localhost:8082/signup ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"Test User\",\"email\":\"test@example.com\",\"password\":\"password123\"}"
```

On Linux/macOS:

```bash
curl -X POST http://localhost:8082/signup \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'
```

The signup route creates:

1. A Serverpod authentication user
2. An email authentication record
3. The application's `User` row
4. The relationship between the two using `authUserId`

It then returns a JWT.

You can subsequently log in using:

```text
Email:    test@example.com
Password: password123
```

---

# Why not manually insert the authentication user?

The Serverpod authentication tables contain password hashes and authentication-specific data.

A simple SQL insert such as:

```sql
INSERT INTO serverpod_auth_idp_email_account ...
```

is not a valid substitute for Serverpod's authentication API unless the password hash and all required authentication records are generated exactly as Serverpod expects.

For local development, use `/signup`.

If you only need products to test the Flutter UI, you do not need to manually create authentication records.

---

# Manually inspecting authentication data

Inside PostgreSQL:

```sql
SELECT * FROM serverpod_auth_core_user;
```

and:

```sql
SELECT * FROM serverpod_auth_idp_email_account;
```

The email authentication table associates an email account with the Serverpod authentication user.

You can inspect the relationship with:

```sql
SELECT
    a.id,
    a."authUserId",
    a.email
FROM serverpod_auth_idp_email_account a;
```

Then inspect the application user:

```sql
SELECT * FROM "user";
```

The application's:

```text
user.authUserId
```

should correspond to the Serverpod authentication user's ID.

---

# Seed products

The `product` table used by ShopWave contains:

```text
id
name
description
price
imageUrl
category
```

The following SQL creates useful development data:

```sql
INSERT INTO product
    (name, description, price, "imageUrl", category)
VALUES
    (
        'Air Max 270',
        'Lightweight everyday sneaker with responsive cushioning.',
        149.99,
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
        'Shoes'
    ),
    (
        'Air Force 1',
        'Classic low-top sneaker designed for everyday wear.',
        119.99,
        'https://images.unsplash.com/photo-1549298916-b41d501d3772',
        'Shoes'
    ),
    (
        'Ultraboost Light',
        'Performance running shoe with responsive cushioning.',
        180.00,
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
        'Running'
    ),
    (
        'Superstar',
        'Classic lifestyle sneaker with a timeless silhouette.',
        95.00,
        'https://images.unsplash.com/photo-1552346154-21d32810aba3',
        'Shoes'
    ),
    (
        '574 Core',
        'Classic everyday sneaker combining comfort and casual styling.',
        89.99,
        'https://images.unsplash.com/photo-1554130841-87d2e4d0f7a5',
        'Lifestyle'
    ),
    (
        'Dri-FIT Training Shirt',
        'Lightweight training shirt designed to move moisture away from the body.',
        39.99,
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
        'Clothing'
    ),
    (
        'Classic Leather',
        'Minimal leather sneaker suitable for casual everyday use.',
        85.00,
        'https://images.unsplash.com/photo-1495555961986-6d4c1ecb7be3',
        'Shoes'
    ),
    (
        'Chuck 70',
        'High-top canvas sneaker with a classic design.',
        110.00,
        'https://images.unsplash.com/photo-1607522370275-f14206abe5d3',
        'Shoes'
    );
```

After inserting them:

```sql
SELECT * FROM product ORDER BY id;
```

The exact remote image URLs are only development examples. Replace them with stable image hosting before production.

---

# Add one product for pull-to-refresh testing

If you want to verify that the Flutter product list actually refreshes from the server, insert a new product while the application is running:

```sql
INSERT INTO product
    (name, description, price, "imageUrl", category)
VALUES
    (
        'React Runner X',
        'A development-only product used to verify pull-to-refresh.',
        129.99,
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
        'Testing'
    );
```

Then pull down on the product list.

The application should invalidate/reload `productsProvider` and display the newly inserted product.

---

# Verify the backend manually

Before debugging Flutter, verify the backend independently.

Products:

```bash
curl http://localhost:8082/products
```

Product details:

```bash
curl http://localhost:8082/products/1
```

Login:

```bash
curl -X POST http://localhost:8082/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

The response should contain a token.

Profile:

```bash
curl http://localhost:8082/profile \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

Orders:

```bash
curl http://localhost:8082/orders \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

This makes it possible to determine whether a problem belongs to the Flutter client or the backend before debugging both simultaneously.

---

# Running the Flutter application

From the Flutter directory:

```bash
flutter pub get
```

Start an Android emulator.

Then:

```bash
flutter run
```

The development API URL is configured as:

```dart
static final baseURL = 'http://10.0.2.2:8082';
```

For an Android emulator:

```text
10.0.2.2 -> host machine
```

Therefore:

```text
Flutter emulator
       |
       | http://10.0.2.2:8082
       v
Host machine
       |
       v
Serverpod
       |
       v
PostgreSQL Docker container
```

If using a physical Android device, `10.0.2.2` will not point to your development machine. Use the machine's local network IP and make sure the backend is reachable from the device.

---

# Development API configuration

The Flutter client currently uses:

```dart
baseURL = 'http://10.0.2.2:8082';
```

For production, the application is structured so the base URL can be changed to the deployed API endpoint.

Do not hard-code production credentials or secrets into the Flutter source code.

---

# Main dependencies

## Flutter

The application is built with Flutter and Dart.

## Riverpod

Used for:

- Application state
- Async state
- Derived state
- Parameterized providers
- Provider lifecycle
- Reactive UI updates
- Side effects/listeners

## Dio

Used for:

- HTTP requests
- Request configuration
- Authentication headers
- Logging
- Error handling
- REST communication

## GoRouter

Used for:

- Declarative navigation
- Path parameters
- Protected routes
- Authentication redirects
- Navigation after operations

## SharedPreferences

Used for local session persistence during development.

Stored values include:

```text
JWT token
User ID
Serialized user data
```

For a production application, sensitive authentication tokens should generally be stored using a platform-secure storage mechanism rather than ordinary SharedPreferences.

## Cached Network Image

Used for:

- Remote image loading
- Image caching
- Loading placeholders
- Image error states

## Google Fonts

Used to provide the application's JetBrains Mono typography.

## Intl

Used for formatting order dates.

---

# Domain models

The Flutter application contains domain models for:

```text
User
Product
CartItem
Order
OrderItem
OrderStatus
```

The models contain JSON serialization/deserialization logic and domain-specific behavior.

For example:

```dart
double get subtotal => product.price * quantity;
```

and:

```dart
OrderStatus.fromString(...)
```

keep domain transformations out of UI widgets.

---

# Order status

Orders support:

```text
pending
processing
shipped
delivered
cancelled
```

Each status has a user-facing label and presentation properties.

This keeps status-specific UI behavior associated with the domain model rather than scattering status conditionals throughout screens.

---

# Error handling

The application handles HTTP errors at the authentication layer and asynchronous errors at the provider/UI layer.

Authentication errors map HTTP status codes to user-readable messages.

For example:

```text
400 -> Bad request
401 -> Incorrect credentials
403 -> Forbidden
404 -> Not found
429 -> Too many requests
500 -> Server error
```

Other errors fall back to a generic message.

Asynchronous feature providers expose errors through `AsyncValue`.

---

# Manual test checklist

After setting up the backend and database, verify the following.

## Authentication

- Start backend
- Start Flutter
- Create `test@example.com`
- Log in
- Verify the JWT is returned
- Restart the application
- Verify the session is restored
- Log out
- Verify protected routes redirect to login

## Products

- Load product list
- Verify loading state
- Verify product cards
- Verify remote images
- Verify image placeholders
- Verify image error handling
- Open a product
- Verify product detail provider
- Pull to refresh
- Insert a product through PostgreSQL
- Pull to refresh again
- Verify the new product appears

## Cart

- Add product
- Add same product again
- Verify quantity increases
- Increase quantity
- Decrease quantity
- Remove product
- Verify cart count
- Verify cart total
- Verify empty-cart behavior

## Checkout

- Add multiple products
- Open checkout
- Verify item count
- Verify quantities
- Verify prices
- Verify total
- Confirm order
- Verify loading state
- Verify navigation to order success

## Orders

- Open order history
- Verify newly created order
- Verify total
- Verify item count
- Verify status
- Verify date formatting
- Test retry behavior after an API failure

## Profile

- Open profile
- Verify user data
- Open order history
- Log out
- Verify authentication state changes

---

# Project design principles

The project follows several practical principles.

## Keep business state out of widgets

Widgets display state and trigger operations.

State-changing logic belongs in Riverpod notifiers/providers.

## Keep remote state asynchronous

Network-backed state uses `AsyncValue` rather than manually managing multiple loading/error variables.

## Derive instead of duplicating

Cart count and cart total are calculated from the cart rather than stored as separate mutable state.

This avoids multiple sources of truth.

## Parameterize repeated operations

Product detail data uses a family provider rather than creating a provider for every product.

## Scope state appropriately

`autoDispose` is used where provider state is tied to a screen/detail instance.

## Separate authentication from application data

Serverpod's authentication system handles identity and credentials while the application `User` model stores application-specific information.

## Keep navigation reactive

GoRouter is notified when authentication state changes so route access remains synchronized with the application state.

---

# Production considerations

This project is a development/portfolio application and is not presented as production-ready infrastructure.

Before production deployment, several areas should be hardened.

### Secure token storage

The current Flutter implementation uses SharedPreferences for session persistence.

A production implementation should use secure platform storage for authentication credentials.

### Logging

Development logging currently prints HTTP requests and authentication-related information.

Sensitive information such as JWTs should never be logged in production.

### Image hosting

Development product images use remote URLs.

Production images should be served from controlled, reliable infrastructure with appropriate caching and optimization.

### API configuration

The API base URL should be environment-specific rather than manually edited in source code.

### Database migrations

Production migrations should be versioned and applied deliberately rather than relying on development database state.

### Validation

Backend validation should be comprehensive for:

- Authentication input
- Product IDs
- Quantities
- Prices
- Order payloads
- Authorization
- Resource ownership

### Transaction boundaries

Order creation should be performed atomically on the backend so that partial order data cannot be persisted if one part of the operation fails.

---

# What this project demonstrates

ShopWave demonstrates practical experience with:

```text
Flutter
Dart
Feature-first architecture
Riverpod
Notifier
AsyncNotifier
AsyncValue
Provider
select
family
autoDispose
ref.watch
ref.read
ref.listen
Derived state
Dio
REST APIs
JWT authentication
Serverpod
PostgreSQL
Docker
GoRouter
Protected routing
Persistent sessions
JSON serialization
Async error handling
Loading states
Pull-to-refresh
Remote image caching
Cart state management
Checkout flows
Order management
Database relationships
Authentication/application-user relationships
Responsive Flutter layouts
Material 3
```

More importantly, the project demonstrates how these technologies interact in an actual application rather than in isolated examples.

The architecture intentionally separates:

```text
UI
 |
 v
Riverpod state
 |
 v
HTTP client
 |
 v
REST API
 |
 v
Serverpod
 |
 v
PostgreSQL
```

while keeping feature-specific logic close to the feature that owns it.

---

# Repository setup summary

For a new developer cloning the project:

```bash
# 1. Clone
git clone <repository-url>

# 2. Start PostgreSQL
cd shopwave_backend_server
docker compose up -d

# 3. Configure Serverpod secrets
# Create config/passwords.yaml locally.
# Do not commit secrets.

# 4. Generate Serverpod code
serverpod generate

# 5. Apply backend database migrations
# Use the migration commands/configuration for the backend.

# 6. Start the Serverpod backend
dart run bin/main.dart

# 7. Create a development account
curl -X POST http://localhost:8082/signup \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'

# 8. Seed products
# Run the SQL INSERT statements in this README.

# 9. Start Flutter
cd ../showave
flutter pub get
flutter run
```

The exact Serverpod startup command may differ depending on the backend's generated project configuration. Use the backend's `bin/main.dart` and Serverpod project configuration if it defines a different command.

---

# Troubleshooting

## Flutter receives 401 from `/login`

Verify that the email account exists in:

```sql
SELECT * FROM serverpod_auth_idp_email_account;
```

and that the authentication user exists in:

```sql
SELECT * FROM serverpod_auth_core_user;
```

For a new development account, use `/signup` instead of manually inserting authentication records.

---

## `/profile` returns 401

Verify:

1. Flutter sends:

```http
Authorization: Bearer <token>
```

2. The JWT is still valid.
3. Serverpod authentication is correctly configured.
4. The authenticated Serverpod user exists.
5. The application's `user.authUserId` matches the authenticated Serverpod user ID.

---

## `authUserId` does not exist on `UserTable`

The generated Serverpod code is out of sync with the model/database.

Run the Serverpod generation process and make sure the migration containing the new field has been applied.

---

## PostgreSQL says a column does not exist

This usually indicates that the generated Serverpod model and PostgreSQL schema are at different versions.

Check:

```sql
\d user
```

and compare it with the current Serverpod model.

---

## Android cannot connect to the backend

For an Android emulator use:

```text
10.0.2.2
```

instead of:

```text
localhost
```

For example:

```text
http://10.0.2.2:8082
```

For a physical Android device, use the host computer's LAN IP.

---

## Images load slowly

Verify:

- The image URL is reachable
- The image host is responding
- `CachedNetworkImage` is being used
- The emulator has network access

The application includes cached image loading and explicit placeholder/error states.

---

# Current project status

This repository represents an actively developed learning/portfolio application. The focus is on demonstrating practical Flutter architecture, state management, asynchronous workflows, REST integration, authentication, and backend integration.

Some production concerns intentionally remain outside the scope of the current implementation, particularly secure token storage, production logging configuration, deployment infrastructure, and hardened backend validation.

The codebase is structured so these concerns can be introduced without replacing the application's core architecture.

---

# Author

Built as a full-stack Flutter and Serverpod project to explore production-style application architecture, reactive state management, authentication, REST APIs, PostgreSQL persistence, and end-to-end e-commerce workflows.
