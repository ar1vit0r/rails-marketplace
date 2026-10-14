# Roadmap

## Pending verification

- **Confirm `assume_ssl`/`force_ssl` took effect in production** (2026-09-12): pushed in `7a94de4`
  (`config/environments/production.rb`), but `curl -I https://rails-marketplace-etdm.onrender.com`
  still showed no `Strict-Transport-Security` header and a `set-cookie` without `Secure`. Re-check
  after confirming a deploy actually ran.
- **Verify Render auto-deploy is actually wired**: README claims deploys are "configured via
  `render.yaml` (Blueprints)" with auto-deploy on push to `main`, but no `render.yaml` exists in
  the repo. Check the Render dashboard for how this service is actually configured, and either add
  the missing `render.yaml` or correct the README.

## Known gaps

- **`categories/show` still has the old look** (2026-10-14): it renders its own card inline with
  light-theme classes (`bg-white`, `text-gray-900`, `text-indigo-600`) on the dark body, so the
  title and card text are dark on dark. Home and `products/index` use the `products/_plate`
  partial. Fix by rendering `_plate` and matching the `products/index` heading and pagination.
