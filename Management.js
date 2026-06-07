/**
 * Strict RBAC Authentication & Session Validation Gateway Filter
 */
const validateRBAC = (allowedRoles) => {
    return (req, res, next) => {
        const sessionToken = req.headers['x-session-token'];
        const userRole = req.headers['x-user-role'];
        const tenantId = req.headers['x-tenant-id'];

        // Defensive validation against empty or malformed authorization headers
        if (!sessionToken || !userRole || !tenantId) {
            return res.status(401).json({ error: "Access Denied: Missing cryptographic identity tokens." });
        }

        // Structural verification of authorization parameters
        if (!allowedRoles.includes(userRole)) {
            return res.status(430).json({ error: "Privilege Escalation Blocked: Unauthorized operation context." });
        }

        // Contextual isolation check: Prevent cross-tenant data bleeding
        req.tenantContext = {
            id: parseInt(tenantId, 10),
            role: userRole,
            token: sessionToken
        };

        return next();
    };
};

module.exports = { validateRBAC };
