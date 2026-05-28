<<<<<<< HEAD
# 🐳 Jenkins + Docker Web Server Pipeline

> Full CI/CD pipeline: GitHub → Jenkins → Docker → Running Web Server

---

## 📁 Project Structure

```
jenkins-docker-project/
├── app/
│   └── index.html          ← Your web application
├── Dockerfile              ← Container definition
├── Jenkinsfile             ← CI/CD pipeline stages
├── docker-compose.yml      ← Local dev / Jenkins setup
├── .gitignore
└── README.md
```

---

## ⚙️ Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Git | Any | https://git-scm.com |
| Docker | 20+ | https://docker.com |
| Jenkins | LTS | https://jenkins.io |
| Docker Hub account | — | https://hub.docker.com |

---

## 🚀 Step-by-Step Setup

### Step 1 — Push Project to GitHub

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/jenkins-docker-webserver.git
git push -u origin main
```

### Step 2 — Install & Start Jenkins

**Option A — Docker (recommended):**
```bash
docker-compose up -d jenkins
```

**Option B — Native install (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install -y openjdk-17-jdk
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update && sudo apt install -y jenkins
sudo systemctl start jenkins && sudo systemctl enable jenkins
```

### Step 3 — Unlock Jenkins

Open `http://localhost:8081` and get the initial admin password:
```bash
docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword
# or (native install)
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Step 4 — Install Jenkins Plugins

Go to: **Manage Jenkins → Plugins → Available**

Install these plugins:
- ✅ Git Plugin
- ✅ Pipeline Plugin
- ✅ Docker Pipeline Plugin
- ✅ Credentials Binding Plugin

### Step 5 — Add Docker Hub Credentials

1. Go to **Manage Jenkins → Credentials → Global → Add Credentials**
2. Kind: **Username with password**
3. ID: `dockerhub-credentials`
4. Enter your Docker Hub username & password/token

### Step 6 — Allow Jenkins to Use Docker

```bash
# Add jenkins user to docker group (native install)
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Step 7 — Create Jenkins Pipeline Job

1. Click **New Item → Pipeline**
2. Name it: `docker-webserver-pipeline`
3. Under **Pipeline → Definition** select: **Pipeline script from SCM**
4. SCM: **Git**
5. Repository URL: `https://github.com/YOUR_USERNAME/jenkins-docker-webserver.git`
6. Branch: `*/main`
7. Script Path: `Jenkinsfile`
8. Click **Save**

### Step 8 — Configure GitHub Webhook (Auto-Trigger)

In your GitHub repo:
1. Go to **Settings → Webhooks → Add webhook**
2. Payload URL: `http://YOUR_JENKINS_IP:8081/github-webhook/`
3. Content type: `application/json`
4. Trigger: **Just the push event**
5. Click **Add webhook**

### Step 9 — Run the Pipeline!

Click **Build Now** in Jenkins.

Watch the stages run:
```
✅ 1 · Checkout from GitHub
✅ 2 · Build Docker Image
✅ 3 · Test Container
✅ 4 · Push to Docker Hub
✅ 5 · Deploy Web Server
✅ 6 · Cleanup Old Images
```

### Step 10 — View Your Running Website

Open your browser:
```
http://localhost:8080
```

---

## 🔄 How the Pipeline Works

```
Push to GitHub
      │
      ▼
Jenkins detects change (webhook or poll)
      │
      ▼
Stage 1: git clone / checkout
      │
      ▼
Stage 2: docker build -t my-webserver .
      │
      ▼
Stage 3: Smoke test (curl → HTTP 200?)
      │
      ├── FAIL → Pipeline stops, reports error
      │
      ▼
Stage 4: docker push → Docker Hub
      │
      ▼
Stage 5: Stop old container → Run new container
      │
      ▼
Stage 6: Prune old images
      │
      ▼
🎉 Live at http://localhost:8080
```

---

## 🛠️ Useful Commands

```bash
# View running containers
docker ps

# See container logs
docker logs webserver-container

# Stop the web server
docker stop webserver-container

# Rebuild locally without Jenkins
docker build -t my-webserver . && docker run -d -p 8080:80 my-webserver

# View Jenkins logs
docker logs jenkins-server
```

---

## 🧯 Troubleshooting

| Problem | Fix |
|---------|-----|
| Jenkins can't run Docker | Run `sudo usermod -aG docker jenkins && sudo systemctl restart jenkins` |
| Port 8080 in use | Change `HOST_PORT` in Jenkinsfile |
| Push to Docker Hub fails | Check credentials ID matches `dockerhub-credentials` |
| Webhook not firing | Ensure Jenkins URL is publicly accessible |

---

## 📄 License

MIT — free to use and modify.
=======
# webserver-docker
Now let me create all the project files — the complete Jenkins CI/CD pipeline project with Docker for a web server.
>>>>>>> fd0c1f2274f154e9fe7dc3c9925dc0d3ee525259
