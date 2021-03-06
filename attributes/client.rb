#
# Cookbook Name:: percona
# Attributes:: client
#

# install vs. upgrade packages
default["percona"]["client"]["package_action"] = "install"

version = value_for_platform_family(
  "debian" => node["percona"]["version"],
  "rhel" => node["percona"]["version"].tr(".", "")
)

case node["platform_family"]
when "debian"
  abi_version = case version
                when "5.5" then "18"
                when "5.6" then "18.1"
                when "5.7" then "10"
                else ""
                end

  if Array(node["percona"]["server"]["role"]).include?("cluster")
    default["percona"]["client"]["packages"] = %W[
      libperconaserverclient#{abi_version}-dev percona-xtradb-cluster-client-#{version}
    ]
  else
    default["percona"]["client"]["packages"] = %W[
      libperconaserverclient#{abi_version}-dev percona-server-client-#{version}
    ]
  end
when "rhel"
  if Array(node["percona"]["server"]["role"]).include?("cluster")
    default["percona"]["client"]["packages"] = %W[
      Percona-XtraDB-Cluster-client-#{version}
    ]
      #Percona-XtraDB-Cluster-devel-#{version} 
  else
    default["percona"]["client"]["packages"] = %W[
      Percona-Server-client-#{version}
    ]
      #Percona-Server-devel-#{version} 
  end
end
