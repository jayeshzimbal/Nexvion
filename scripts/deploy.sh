#!/bin/bash
echo "Starting Nexvion deployment..."
docker build -t nexvion-app:latest -f docker/Dockerfile .
docker run -d -p 8080:80 --name nexvion-container nexvion-app:latest
echo "Nexvion application successfully deployed on port 8080!"
EOF

cat << 'EOF' > scripts/health-check.sh
#!/bin/bash
echo "Checking application health..."
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/index.html)
if [ "$STATUS_CODE" -eq 200 ]; then
    echo "Application is Healthy (HTTP 200 OK)"
    exit 0
else
    echo "Application Health Check Failed (HTTP $STATUS_CODE)"
    exit 1
fi
