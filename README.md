# Rails Marketplace

A full-stack e-commerce marketplace built with Rails 8, featuring a shopping cart, order system, and admin dashboard.

**[Live Demo](https://rails-marketplace-etdm.onrender.com)**

## Highlights

- **Product browsing** — Search by name, filter by category
- **Shopping cart** — Add/remove items, quantity tracking
- **Order placement** — Checkout flow with order history
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
