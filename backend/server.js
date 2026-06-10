const express = require('express');
const cors = require('cors');
const midtransClient = require('midtrans-client');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// Initialize Midtrans Snap client
const snap = new midtransClient.Snap({
    isProduction: true,
    serverKey: process.env.MIDTRANS_SERVER_KEY,
    clientKey: process.env.MIDTRANS_CLIENT_KEY
});

// Endpoint to generate transaction token
app.post('/api/payment/token', async (req, res) => {
    try {
        const { order_id, gross_amount, customer_details, item_details } = req.body;

        const parameter = {
            transaction_details: {
                order_id: order_id || `ORDER-${new Date().getTime()}`,
                gross_amount: gross_amount
            },
            customer_details: customer_details,
            item_details: item_details
        };

        const transaction = await snap.createTransaction(parameter);

        // Return both the token and the redirect URL
        res.status(200).json({
            token: transaction.token,
            redirect_url: transaction.redirect_url
        });
    } catch (error) {
        console.error("Error creating Midtrans transaction:", error);
        res.status(500).json({ error: error.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Midtrans Backend is running on http://localhost:${PORT}`);
    console.log(`Server Key Loaded: ${process.env.MIDTRANS_SERVER_KEY ? "YES" : "NO"}`);
});
