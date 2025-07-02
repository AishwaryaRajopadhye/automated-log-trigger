# 🚀 Automated Jenkins Job Triggered by Access Log Size

## 📌 Objective

Create an automated system that continuously monitors a server access log file.  
When the file exceeds 1GB in size, it should:

- ✅ Trigger a Jenkins pipeline job
- ✅ Upload the log file to an Amazon S3 bucket
- ✅ Verify successful upload
- ✅ Clear the contents of the original log file

---

## 🛠️ Tools & Technologies

- Jenkins (Pipeline Job)
- Bash (Shell Script)
- AWS CLI
- Amazon S3
- Cron (Linux Task Scheduler)
- Ubuntu/Linux OS

---

## ✅ Step 1: Prerequisites Setup

### 🔹 Jenkins Installation (Ubuntu)

```bash
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install openjdk-17-jdk jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
```
Access Jenkins:
```bash
http://<your-server-ip>:8080
```
### 🔹 AWS CLI Setup
```bash
sudo apt install awscli -y
aws configure
```
## Test:
```bash
aws s3 ls
```
### 🔹 Log File Preparation
```bash
sudo mkdir -p /var/log/httpd
sudo truncate -s 0 /var/log/httpd/access.log
```
----
## ✅ Step 2: Shell Script – monitor_log.sh

- Add  monitor_log.sh file
  
- Make executable:
```bash
chmod +x monitor_log.sh
```
----
## ✅ Step 3: Jenkins Pipeline Job

- Add jenkins_pipeline.txt file
---
## ✅ Step 4: Automate with Cron
```bash
crontab -e
```
- Add this line:
```bash
*/5 * * * * /home/ubuntu/automated-log-trigger/monitor_log.sh >> /home/ubuntu/automated-log-trigger/logs/log_monitor.log 2>&1
```
----
## ✅ Step 5: Validation

- S3 Upload Proof
```bash
aws s3 ls s3://YOUR_BUCKET_NAME/ --region YOUR_REGION
```
- Log Cleared
```bash
ls -lh /var/log/httpd/access.log
```




