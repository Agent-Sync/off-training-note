import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.43.2";

const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
const supabaseServiceRoleKey =
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

console.log(
  `${supabaseUrl ? "✅" : "❌"} SUPABASE_URL`,
);
console.log(
  `${supabaseServiceRoleKey ? "✅" : "❌"} SUPABASE_SERVICE_ROLE_KEY`,
);

serve(async (req) => {

  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({ error: "Method not allowed" }),
      { status: 405, headers: { "Content-Type": "application/json" } },
    );
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  if (!authHeader.startsWith("Bearer ")) {
    return new Response(
      JSON.stringify({ error: "Missing Authorization header" }),
      { status: 401, headers: { "Content-Type": "application/json" } },
    );
  }

  const jwt = authHeader.replace("Bearer ", "");

  const supabaseAdmin = createClient(supabaseUrl, supabaseServiceRoleKey, {
    auth: { persistSession: false },
  });

  const { data: { user }, error: userError } = await supabaseAdmin.auth.getUser(
    jwt,
  );
  if (userError) {
    console.error(userError);
    return new Response(
      JSON.stringify({ error: "Invalid user" }),
      { status: 401, headers: { "Content-Type": "application/json" } },
    );
  }
  const userId = user?.id ?? "";
  if (!userId) {
    return new Response(
      JSON.stringify({ error: "Invalid user" }),
      { status: 401, headers: { "Content-Type": "application/json" } },
    );
  }

  const { error: deleteError } = await supabaseAdmin.auth.admin.deleteUser(
    userId,
  );
  if (deleteError) {
    console.error(deleteError);
    return new Response(
      JSON.stringify({ error: "Failed to delete account" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  return new Response(
    JSON.stringify({ ok: true }),
    { status: 200, headers: { "Content-Type": "application/json" } },
  );
});
