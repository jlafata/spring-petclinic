#reference https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-scc-dockerfile-based-builds.html
#
# example following
#tanzu apps workload create foo \
#  --git-repo https://github.com/foo/bar \
#  --git-branch dev \
#  --param dockerfile=./Dockerfile \
#  --type web

tanzu apps workload create petclinic \
   --git-repo https://github.com/jlafata/spring-petclinic \
   --git-branch accelerator \
   --param dockerfile=./Dockerfile \
   --build-env BP_JVM_VERSION=17 \
   --type web \
   --annotation autoscaling.knative.dev/minScale=1 \
   --label app.kubernetes.io/part-of=petclinic \
   --label apps.tanzu.vmware.com/has-tests="true" \
   --yes
