# Rails Marketplace

A full-stack e-commerce marketplace built with Rails 8, featuring a shopping cart, order system, and admin dashboard.

**[Live Demo](https://rails-marketplace-etdm.onrender.com)**

## Highlights

- **Product browsing** — Search by name, filter by category
- **Shopping cart** — Add/remove items, quantity tracking
- **Order placement** — Checkout flow with order history
- **Stripe payments** — Hosted Stripe Checkout with signature-verified webhooks that mark orders paid
- **Admin dashboard** — Manage products, categories, and orders
- **Multi-role auth** — Admin, seller, and regular user roles
- **Pagination** — Server-side pagination via Pagy

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Ruby on Rails 8.1 |
| Language | Ruby 3.4 |
| Database | SQLite (dev) / PostgreSQL (prod) |
| Auth | Devise 5.0 |
| Payments | Stripe Checkout + webhooks |
| Pagination | Pagy |
| Frontend | Tailwind CSS, Importmap |
| Testing | RSpec, FactoryBot, Shoulda Matchers |
| CI | GitHub Actions |
| Deploy | Docker + Render |

## Quick Start

```bash
git clone https://github.com/ar1vit0r/rails-marketplace.git
cd rails-marketplace
bundle install
bin/rails db:create db:migrate db:seed
bin/dev
```

Open [http://localhost:3001](http://localhost:3001).

**Admin login:** `admin@example.com` / `password`
**Seller login:** `seller@example.com` / `password`

## Payments (Stripe)

Paying an order goes through hosted Stripe Checkout:

1. `CheckoutController#create` builds a Checkout Session from the order's items (USD) and stores a `CheckoutSession` record with status `pending`, then redirects to Stripe.
2. Stripe redirects back to `/checkout/success` or `/checkout/cancel`.
3. `POST /webhooks/stripe` verifies the `Stripe-Signature` header against `STRIPE_WEBHOOK_SECRET`. `checkout.session.completed` marks the checkout and the order `paid`; `checkout.session.expired` marks the checkout `expired`.

Environment variables:

| Variable | Purpose |
|----------|---------|
| `STRIPE_SECRET_KEY` | API key used to create Checkout Sessions (read in `config/initializers/stripe.rb`) |
| `STRIPE_WEBHOOK_SECRET` | signing secret of the webhook endpoint pointing at `/webhooks/stripe` |

To try it locally with the [Stripe CLI](https://docs.stripe.com/stripe-cli) and test mode keys:

```bash
export STRIPE_SECRET_KEY=sk_test_...
stripe listen --forward-to localhost:3001/webhooks/stripe   # prints the whsec_... value for STRIPE_WEBHOOK_SECRET
```

Pay with the test card `4242 4242 4242 4242`, any future expiry and any CVC.

## Testing

```bash
bundle exec rspec
```

53 examples across model and request specs.

## Deployment

Configured via `render.yaml` (Blueprints):

1. Push to GitHub
2. Connect Render → New Blueprint
3. Auto-deploys on `main` branch push

## Skills Demonstrated

MVC architecture, RESTful routing, ActiveRecord associations (7 models), Devise authentication, multi-role authorization, shopping cart implementation, order management, search/filter, pagination, database migrations, Docker containerization, CI/CD pipelines, and production deployment.

## License

MIT
