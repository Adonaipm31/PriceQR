const functions = require("firebase-functions");
const fetch = require("node-fetch");

// 🔐 Tu API KEY (SOLO AQUÍ, nunca en Flutter)
const GROQ_API_KEY = "TU_API_KEY_AQUI";

exports.chatIA = functions.https.onRequest(async (req, res) => {
  try {
    // ✅ Permitir solicitudes desde Flutter (CORS)
    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Headers", "Content-Type");

    if (req.method === "OPTIONS") {
      res.status(204).send("");
      return;
    }

    const { mensaje } = req.body;

    if (!mensaje) {
      return res.status(400).json({ error: "Mensaje vacío" });
    }

    const response = await fetch("https://api.groq.com/openai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${GROQ_API_KEY}`,
      },
      body: JSON.stringify({
        model: "llama-3.3-70b-versatile",
        messages: [
          {
            role: "system",
            content: "Eres un asistente útil que responde en español de forma clara.",
          },
          {
            role: "user",
            content: mensaje,
          },
        ],
      }),
    });

    const data = await response.json();

    res.json({
      respuesta: data.choices[0].message.content,
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error en la IA" });
  }
});