import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.43.2";

const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
const supabaseServiceRoleKey =
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

serve(async (req) => {
  console.log("delete-account:start", {
    method: req.method,
    url: req.url,
    headerKeys: Array.from(req.headers.keys()),
  });
  console.log(`${supabaseUrl ? "✅" : "❌"} SUPABASE_URL`);
  console.log(`${supabaseServiceRoleKey ? "✅" : "❌"} SUPABASE_SERVICE_ROLE_KEY`);

  if (req.method !== "POST") {
    console.log("delete-account:invalid-method", { method: req.method });
    return new Response(
      JSON.stringify({ error: "Method not allowed" }),
      { status: 405, headers: { "Content-Type": "application/json" } },
    );
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  console.log("delete-account:auth-header", {
    hasAuthHeader: authHeader.length > 0,
    isBearer: authHeader.startsWith("Bearer "),
    authHeaderLength: authHeader.length,
  });
  if (!authHeader.startsWith("Bearer ")) {
    console.log("delete-account:missing-authorization");
    return new Response(
      JSON.stringify({ error: "Missing Authorization header" }),
      { status: 401, headers: { "Content-Type": "application/json" } },
    );
  }

  const jwt = authHeader.replace("Bearer ", "");
  console.log("delete-account:jwt", { jwtLength: jwt.length });

  const supabaseAdmin = createClient(supabaseUrl, supabaseServiceRoleKey, {
    auth: { persistSession: false },
  });

  const { data: { user }, error: userError } = await supabaseAdmin.auth.getUser(jwt);
  if (userError) {
    console.error("delete-account:get-user-error", userError);
    return new Response(
      JSON.stringify({ error: "Invalid user" }),
      { status: 401, headers: { "Content-Type": "application/json" } },
    );
  }
  const userId = user?.id ?? "";
  console.log("delete-account:user", { userId });
  if (!userId) {
    console.log("delete-account:missing-user-id");
    return new Response(
      JSON.stringify({ error: "Invalid user" }),
      { status: 401, headers: { "Content-Type": "application/json" } },
    );
  }

  const { error: deleteError } = await supabaseAdmin.auth.admin.deleteUser(
    userId,
  );
  if (deleteError) {
    console.error("delete-account:delete-error", deleteError);
    return new Response(
      JSON.stringify({ error: "Failed to delete account" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  console.log("delete-account:success", { userId });
  return new Response(
    JSON.stringify({ ok: true }),
    { status: 200, headers: { "Content-Type": "application/json" } },
  );
});
