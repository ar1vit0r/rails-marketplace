require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :request do
  describe "GET /admin/dashboard" do
    context "when not logged in" do
      it "redirects to login" do
        get admin_dashboard_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in as regular user" do
      before { sign_in create(:user) }

      it "redirects to root" do
        get admin_dashboard_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when logged in as admin" do
      before { sign_in create(:user, :admin) }

      it "returns http success" do
        get admin_dashboard_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
