# Membership, Payments & Notifications

## Screens & routes

| Screen | Route | Args |
|---|---|---|
| Membership Plans (tab 6) | `AppRoutes.membershipPlans` | – |
| Subscription Details | `AppRoutes.subscriptionDetails` | – |
| Renewal | `AppRoutes.renewal` | – |
| Membership History | `AppRoutes.membershipHistory` | – |
| Payment | `AppRoutes.payment` | `PaymentRequest` |
| Payment Confirmation / Receipt | `AppRoutes.paymentConfirmation` | `PaymentReceiptArgs` |
| Payment History | `AppRoutes.paymentHistory` | – |
| Notifications | `AppRoutes.notifications` | – |

## Flows

- **Membership:** Plans → select plan → Payment → Confirmation → membership status updated.
- **Renewal:** Renewal → choose period → Payment → Confirmation.
  If the membership is still active, the new period starts on the current expiry date (no lost days). If it has expired, it starts today.
- **Booking:** Facility → Book → pick date & slot → **Payment** → Confirmation.
  The booking is created only after a successful payment. Cancelling a booking marks its payment as *Refunded*.

## Using it from another feature

```dart
// Pay for something:
Navigator.pushNamed(context, AppRoutes.payment,
    arguments: PaymentRequest.booking(BookingDraft(...)));

// Send an in-app notification:
NotificationController.instance.push(
  title: 'Event reminder',
  body: 'Yoga class starts in 1 hour',
  type: NotificationType.event,
  route: AppRoutes.myEvents, // optional
);

// Bell icon with unread badge:
AppBar(actions: const [NotificationBellButton()])
```

## Demo cards

- `4242 4242 4242 4242`: approved
- `4000 0000 0000 0002`: declined

Use any future expiry and any 3-digit CVV. Mobile wallet: any 11-digit number starting with `01`.

## Backend phase (suggested endpoints)

All models already have `toJson` / `fromJson`.

| Method | Endpoint | Replaces |
|---|---|---|
| GET | `/membership-plans` | `mockMembershipPlans` |
| GET | `/members/me/membership` | `MembershipController._seedMockData` |
| GET | `/members/me/subscriptions` | membership history |
| POST | `/payments` | `PaymentController.processPayment` (keep the same signature) |
| GET | `/payments` | payment history |
| GET | `/payments/{id}/receipt` | receipt |
| GET | `/notifications` · PATCH `/notifications/{id}/read` | `NotificationController` |

Never send full card numbers to your own backend. Use a payment gateway SDK (Paymob / Stripe) that returns a token.
