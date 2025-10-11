# Kubernetes Scenario Based Interview Questions and Answers

## Q. how to restrict ec2 to ping or ssh certain regional servers or urls (ex: urls/nodes from russia)

“To restrict EC2 from accessing specific regions like Russia, I’d place it in a private subnet with no direct internet access, and route all outbound traffic via AWS Network Firewall or a proxy. There I can enforce geo-IP blocking and domain-based restrictions. For AWS services, I’d use VPC endpoint policies and SCP guardrails to block access to disallowed regions. For extra safety, I’d add DNS filtering with Route 53 Resolver Firewall. This way we cover IP, DNS, and cloud service-level restrictions.”

Security Groups / NACLs
Route Traffic via Firewall (Preferred)
VPC Endpoint Policies
DNS-based Blocking
IAM & SCP Guardrails (Org-level)

## Q. how to restrict app url being accessed from russia?

“To restrict access to an app URL from Russia, I’d use a Web Application Firewall (AWS WAF, Azure WAF, or Cloudflare) with Geo-IP rules to block requests from Russian IP ranges. If the app sits behind a CDN like CloudFront, I’d enable geo-restriction there as an extra layer. For APIs behind NGINX/Envoy, we can enforce geo-IP blocking at the proxy. This layered approach ensures requests from disallowed regions are blocked at the edge, before they even hit the application.”

Web Application Firewall (WAF) – Recommended
CDN Layer (CloudFront / Azure Front Door / Cloudflare)
Reverse Proxy / API Gateway
DNS-based Blocking
App-level Controls

## Q. compliance-as-code how to implement if my infra code and app code align with compliance?

“To align infra and app code with compliance, I’d implement Compliance-as-Code using tools like OPA and Checkov. For infrastructure, every Terraform or Helm commit would run through policy checks — e.g., ensuring encryption, no public resources, region restrictions. For application code, I’d enforce SAST, DAST, and container scanning in CI/CD. Only if both pass compliance gates does deployment proceed. On top of that, I’d use Kubernetes admission controllers and AWS Config/Azure Policy to continuously enforce compliance in production. This way compliance is automated, auditable, and doesn’t rely on manual review.”

1. Define Compliance Policies as Code
2. Integrate into Infra-as-Code (Terraform/CloudFormation)
3. Integrate into CI/CD for Application Code
4. Align Infra + App
5. Continuous Runtime Compliance

## Q. 3 customer apps running on same EKS cluster configured to run on isolated nodes using taints and tolerations. whats the problem running apps like that and what are the better alternatives?

“Running apps on isolated nodes using taints and tolerations works, but it’s not optimal. It leads to underutilized nodes, high costs, and weak isolation since the control plane and networking are still shared.
For stronger multi-tenancy, I’d consider alternatives:
For internal apps, use namespaces + quotas + network policies.
For customer-facing SaaS, use separate EKS clusters per customer or virtual clusters for better isolation.
This way, we balance cost, performance, and compliance, depending on the tenant requirements.”

Current Setup (What you described) - 3 customer apps on one EKS cluster. - Each app scheduled on separate nodes using taints & tolerations → isolation at node level.
Problems with This Approach - Wasted Capacity - Operational Overhead - Weak Isolation - still share API server, etcd, kube-proxy, and CNI network. - Cluster Resource Contention - Even if on separate nodes, control plane is shared → burst in one tenant can impact API server performance. - Complex Upgrades & DR
Better Alternatives - Option 1 – Namespaces + Quotas + NetworkPolicies (Light Multi-Tenancy) - Option 2 – Dedicated NodePools per App with Labels (Your current approach, but improved) - Option 3 – Separate EKS Clusters per Customer (Strong Isolation) - Option 4 – Virtual Clusters / vCluster (Loft Labs) - Option 5 – Managed Multi-Tenant Platform

## Q. kubernetes service 1 not able to communicate to service 2 how do you troubleshoot?

“First I’d check Service2’s endpoints and selectors. Then verify DNS resolution from Service1 to Service2. If DNS works, I’d test connectivity with curl/nc to confirm port mismatch vs timeout. If traffic is blocked, I’d check readiness probes, NetworkPolicies, and cloud firewalls. Finally, if pods can’t talk even by IP, I’d look into kube-proxy or the CNI plugin. This structured approach usually isolates whether it’s a service definition, DNS, app health, or network policy issue.”

Verify Service & Endpoints
Test DNS Resolution
Test Network Connectivity
Check Pod Health
Check Network Policies / Firewalls
Inspect Logs
CNI / Node-Level Issues

## Q. how prometheus collects metrics, you prefre push methodn or pull method and what are the tools for push/pull metrics?

pull method
push method

“Prometheus is fundamentally pull-based, and I prefer to stick with pull for most workloads because it keeps things consistent, leverages service discovery, and simplifies debugging. For short-lived jobs or cases where scraping isn’t practical, I use the Pushgateway. So in practice, I recommend pull as the default, with push only for edge cases.”

## Q. how to aggregate logs into s3 bucket from kubernetes?

1. Fluent Bit (Recommended)
2. Fluentd
3. AWS for Fluent Bit (EKS)
4. Filebeat + Logstash

Key Considerations:

- IAM Authentication:
- Log Structure:
- Buffer & Performance:
- Cost Optimization:
