import { serve } from "https://deno.land/x/std@0.161.0/http/server.ts";

const mailersendApiUrl = "https://api.mailersend.com/v1/email";
const mailersendApiKey = Deno.env.get("MAILERSEND_API_KEY");

if (!mailersendApiKey) {
  console.error("❌ MAILERSEND_API_KEY is missing in environment variables.");
}

function generateOtp(): string {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

serve(async (req) => {
  console.log("📩 Received request to send OTP");

  try {
    const { email } = await req.json();

    if (!email || !email.includes("@")) {
      console.warn("⚠️ Invalid email provided:", email);
      return new Response("Invalid email address", { status: 400 });
    }

    const otp = generateOtp();
    console.log(`🔐 Generated OTP for ${email}: ${otp}`);

    const emailData = {
      from: {
        email: "your_verified@yourdomain.com", // Replace with your MailerSend verified sender
        name: "MuseFlow App",
      },
      to: [{ email }],
      subject: "Your OTP for Signup",
      text: `Your OTP code is: ${otp}`,
    };

    const response = await fetch(mailersendApiUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${mailersendApiKey}`,
      },
      body: JSON.stringify(emailData),
    });

    if (response.ok) {
      console.log(`✅ OTP email sent to ${email}`);
      return new Response(
        JSON.stringify({ otp }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    } else {
      const errorDetails = await response.text();
      console.error("❌ Failed to send email via MailerSend:", errorDetails);
      return new Response("Failed to send OTP", { status: 500 });
    }
  } catch (error) {
    console.error("❌ Unexpected error:", error);
    return new Response("Failed to send OTP", { status: 500 });
  }
});
