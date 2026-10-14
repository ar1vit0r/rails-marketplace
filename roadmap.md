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
