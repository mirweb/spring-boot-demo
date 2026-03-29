#!/usr/bin/env fish
# Try all 3 OCI availability domains in eu-frankfurt-1 until one has capacity.

set tfvars (dirname (status --current-filename))/../terraform.tfvars

for idx in 0 1 2
    echo ""
    echo "==> Trying availability_domain_index = $idx"

    # Update the index in terraform.tfvars
    sed -i '' "s/^availability_domain_index = .*/availability_domain_index = $idx/" $tfvars

    tofu apply -auto-approve
    if test $status -eq 0
        echo ""
        echo "==> Success with availability_domain_index = $idx"
        exit 0
    end

    echo "==> AD $idx failed, trying next..."
end

echo ""
echo "==> All ADs exhausted. Try a different region (e.g. us-ashburn-1)."
exit 1
