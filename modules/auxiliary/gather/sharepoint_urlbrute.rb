##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
# http://metasploit.com/framework/
##

require 'msf/core'

class Metasploit3 < Msf::Auxiliary

	include Msf::Exploit::Remote::HttpClient
	include Msf::Auxiliary::Report

	def initialize
		super(
			'Name'					 => 'Sharepoint URL Brute',
			'Description'		=> %q{
				Sharepoint admin interface bruting
			},
			'Author'				 =>
				[
					'Stach & Lui', 'jcran'
				],
			'License'				=> MSF_LICENSE,
		)

		register_options(
			[
				OptInt.new('RPORT', [ true, "The target port", 80]),
				OptString.new('APP_PATH', [ false, "The application path", ""]),
			], self.class)

	end

	def cleanup
	end

	def run

		paths = 
		[   '/allcomments.aspx',
				'/allitems.aspx',
				'/allposts.aspx',
				'/archive.aspx',
				'/byauthor.aspx',
				'/calendar.aspx',
				'/_catalogs/',
				'/_catalogs/lt/',
				'/_catalogs/lt/forms/allitems.aspx',
				'/_catalogs/lt/forms/dispform.aspx',
				'/_catalogs/lt/forms/editform.aspx',
				'/_catalogs/lt/forms/upload.aspx',
				'/_catalogs/lt/forms/Allitems.aspx',
				'/_catalogs/lt/forms/DispForm.aspx',
				'/_catalogs/lt/forms/EditForm.aspx',
				'/_catalogs/lt/forms/Upload.aspx',
				'/_catalogs/lt/forms/_vti_cnf/allitems.aspx',
				'/_catalogs/lt/forms/_vti_cnf/editform.aspx',
				'/_catalogs/lt/forms/_vti_cnf/dispform.aspx',
				'/_catalogs/lt/forms/_vti_cnf/upload.aspx',
				'/_catalogs/lt/forms/_vti_cnf/AllItems.aspx',
				'/_catalogs/lt/forms/_vti_cnf/EditForm.aspx',
				'/_catalogs/lt/forms/_vti_cnf/DispForm.aspx',
				'/_catalogs/lt/forms/_vti_cnf/Upload.aspx',
				'/_catalogs/masterpage',
				'/_catalogs/masterpage/Forms/AllItems.aspx',
				'/_catalogs/wp/',
				'/_catalogs/wp/mscontenteditor.dwp',
				'/_catalogs/wp/msimage.dwp',
				'/_catalogs/wp/msmembers.dwp',
				'/_catalogs/wp/mspageviewer.dwp',
				'/_catalogs/wp/mssimpleform.dwp',
				'/_catalogs/wp/msxml.dwp',
				'/_catalogs/wp/_vti_cnf/mscontenteditor.dwp',
				'/_catalogs/wp/_vti_cnf/msimage.dwp',
				'/_catalogs/wp/_vti_cnf/msmembers.dwp',
				'/_catalogs/wp/_vti_cnf/mspageviewer.dwp',
				'/_catalogs/wp/_vti_cnf/mssimpleform.dwp',
				'/_catalogs/wp/_vti_cnf/msxml.dwp',
				'/_catalogs/wp/forms/',
				'/_catalogs/wp/Forms/AllItems.aspx',
				'/_catalogs/wp/Forms/dispform.aspx',
				'/_catalogs/wp/Forms/editform.aspx',
				'/_catalogs/wp/Forms/upload.aspx',
				'/_catalogs/wp/Forms/AllItems.aspx',
				'/_catalogs/wp/Forms/DispForm.aspx',
				'/_catalogs/wp/Forms/EditForm.aspx',
				'/_catalogs/wp/Forms/Upload.aspx',
				'/_catalogs/wp/forms/_vti_cnf/AllItems.aspx',
				'/_catalogs/wp/forms/_vti_cnf/dispform.aspx',
				'/_catalogs/wp/forms/_vti_cnf/editform.aspx',
				'/_catalogs/wp/forms/_vti_cnf/upload.aspx',
				'/_catalogs/wp/forms/_vti_cnf/AllItems.aspx',
				'/_catalogs/wp/forms/_vti_cnf/DispForm.aspx',
				'/_catalogs/wp/forms/_vti_cnf/EditForm.aspx',
				'/_catalogs/wp/forms/_vti_cnf/Upload.aspx',
				'/_catalogs/wt/',
				'/_catalogs/wt/Forms/allitems.aspx',
				'/_catalogs/wt/Forms/common.aspx',
				'/_catalogs/wt/Forms/dispform.aspx',
				'/_catalogs/wt/Forms/editform.aspx',
				'/_catalogs/wt/Forms/upload.aspx',
				'/_catalogs/wt/Forms/AllItems.aspx',
				'/_catalogs/wt/Forms/Common.aspx',
				'/_catalogs/wt/Forms/DispForm.aspx',
				'/_catalogs/wt/Forms/EditForm.aspx',
				'/_catalogs/wt/Forms/Upload.aspx',
				'/_catalogs/wt/Forms/_vti_cnf/allitems.aspx',
				'/_catalogs/wt/Forms/_vti_cnf/common.aspx',
				'/_catalogs/wt/Forms/_vti_cnf/dispform.aspx',
				'/_catalogs/wt/Forms/_vti_cnf/editform.aspx',
				'/_catalogs/wt/Forms/_vti_cnf/upload.aspx',
				'/_catalogs/wt/Forms/_vti_cnf/AllItems.aspx',
				'/_catalogs/wt/Forms/_vti_cnf/Common.aspx',
				'/_catalogs/wt/Forms/_vti_cnf/DispForm.aspx',
				'/_catalogs/wt/Forms/_vti_cnf/EditForm.aspx',
				'/_catalogs/wt/Forms/_vti_cnf/Upload.aspx',
				'/categories/allcategories.aspx',
				'/categories/SOMEOTHERDIR/allcategories.aspx',
				'/categories/viewcategory.aspx',
				'/default.aspx',
				'/directory/_layouts/',
				'/editdocs.aspx',
				'/Forms/AllItems.aspx',
				'/Forms/DispForm.aspx',
				'/Forms/DispForm.aspx?ID=1',
				'/Forms/EditForm.aspx',
				'/Forms/EditForm.aspx?ID=1',
				'/Forms/Forms/AllItems.aspx',
				'/forms/mod-view.aspx',
				'/Forms/mod-view.aspx',
				'/Forms/MyItems.aspx',
				'/forms/my-sub.aspx',
				'/Forms/my-sub.aspx',
				'/Forms/NewForm.aspx',
				'/forms/webfldr.aspx',
				'/Forms/webfldr.aspx',
				'/_layouts/1033',
				'/_layouts/1033/IMAGES',
				'/_layouts/aclinv.aspx',
				'/_layouts/addrole.aspx',
				'/_layouts/AdminRecycleBin.aspx',
				'/_layouts/areanavigationsettings.aspx',
				'/_layouts/AreaTemplateSettings.aspx',
				'/_layouts/AreaWelcomePage.aspx',
				'/_layouts/associatedgroups.aspx',
				'/_Layouts/authenticate.aspx',
				'/_layouts/bpcf.aspx',
				'/_layouts/ChangeSiteMasterPage.aspx',
				'/_layouts/create.aspx',
				'/_layouts/editgrp.aspx',
				'/_layouts/editprms.aspx',
				'/_layouts/groups.aspx',
				'/_layouts/help.aspx',
				'/_layouts/images/',
				'/_layouts/listedit.aspx',
				'/_layouts/listfeed.aspx',
				'/_layouts/ManageFeatures.aspx',
				'/_layouts/ManageFeatures.aspx?Scope=Site',
				'/_layouts/mcontent.aspx',
				'/_layouts/mngctype.aspx',
				'/_layouts/mngfield.aspx',
				'/_layouts/mngsiteadmin.aspx',
				'/_layouts/mngsubwebs.aspx',
				'/_layouts/mngsubwebs.aspx?view=sites',
				'/_layouts/myinfo.aspx',
				'/_layouts/MyPage.aspx',
				'/_layouts/MyTasks.aspx',
				'/_layouts/navoptions.aspx',
				'/_layouts/NewDwp.aspx',
				'/_layouts/newgrp.aspx',
				'/_layouts/newsbweb.aspx',
				'/_layouts/PageSettings.aspx',
				'/_layouts/people.aspx',
				'/_layouts/people.aspx?MembershipGroupId=0',
				'/_layouts/permsetup.aspx',
				'/_layouts/picker.aspx',
				'/_layouts/policy.aspx',
				'/_layouts/policyconfig.aspx',
				'/_layouts/policycts.aspx',
				'/_layouts/Policylist.aspx',
				'/_layouts/prjsetng.aspx',
				'/_layouts/quiklnch.aspx',
				'/_layouts/recyclebin.aspx',
				'/_Layouts/RedirectPage.aspx?Target={SiteCollectionUrl}_catalogs/masterpage',
				'/_layouts/role.aspx',
				'/_layouts/settings.aspx',
				'/_layouts/SiteDirectorySettings.aspx',
				'/_layouts/sitemanager.aspx',
				'/_Layouts/SiteManager.aspx?lro=all',
				'/_layouts/spcf.aspx',
				'/_layouts/storman.aspx',
				'/_layouts/themeweb.aspx',
				'/_layouts/topnav.aspx',
				'/_layouts/user.aspx',
				'/_layouts/userdisp.aspx',
				'/_layouts/userdisp.aspx?ID=1',
				'/_layouts/useredit.aspx',
				'/_layouts/useredit.aspx?ID=1&Source=/_layouts/people.aspx',
				'/_layouts/viewgrouppermissions.aspx',
				'/_layouts/viewlsts.aspx',
				'/_layouts/vsubwebs.aspx',
				'/_layouts/WPPrevw.aspx?ID=247',
				'/_layouts/wrkmng.aspx',
				'/lists/',
				'/lists/tasks/',
				'/lists/Tasks/AllItems.aspx',
				'/Lists/Announcements/',
				'/Lists/Announcements/AllItems.aspx',
				'/Lists/Announcements/titles.aspx',
				'/Lists/Contacts/',
				'/Lists/Contacts/AllItems.aspx',
				'/Lists/Contacts/filter.aspx',
				'/Lists/blog/',
				'/Lists/blog/AllItems.aspx',
				'/Lists/FAQs/',
				'/Lists/FAQs/AllItems.aspx',
				'/Lists/Registration/',
				'/Lists/Registration/AllItems.aspx',
				'/Lists/Links/',
				'/Lists/Links/AllItems.aspx',
				'/Lists/Events/',
				'/Lists/Events/AllItems.aspx',
				'/Lists/Events/MyItems.aspx',
				'/lists/asppop3.asp',
				'/lists/readmessage.asp',
				'/lists/stylesheet.css',
				'/mod-view.aspx',
				'/mycategories.aspx',
				'/mycomments.aspx',
				'/myposts.aspx',
				'/my-sub.aspx',
				'/Pages/categoryresults.aspx',
				'/Pages/default.aspx',
				'/Pages/Forms/AllItems.aspx',
				'/Pages/login.aspx',
				'/shared documents/forms/allitems.aspx',
				'/Shared Documents/Forms/AllItems.aspx',
				'/sitedirectory',
				'/sites/random%20crazy%20string',
				'/SSP/Admin/_layouts/viewscopesssp.aspx?mode=ssp',
				'/_vti_bin/Admin.asmx',
				'/_vti_bin/alerts.asmx',
				'/_vti_bin/AreaService.asmx',
				'/_vti_bin/BusinessDataCatalog.asmx',
				'/_vti_bin/copy.asmx',
				'/_vti_bin/dspsts.asmx',
				'/_vti_bin/ExcelService.asmx',
				'/_vti_bin/forms.asmx',
				'/_vti_bin/Lists.asmx',
				'/_vti_bin/people.asmx',
				'/_vti_bin/Permissions.asmx',
				'/_vti_bin/search.asmx',
				'/_vti_bin/SharepointEmailWS.asmx',
				'/_vti_bin/sitedata.asmx',
				'/_vti_bin/sites.asmx',
				'/_vti_bin/spscrawl.asmx',
				'/_vti_bin/spsdisco.aspx',
				'/_vti_bin/spsearch.asmx',
				'/_vti_bin/UserGroup.asmx',
				'/_vti_bin/usergroup.asmx',
				'/_vti_bin/UserProfileService.asmx',
				'/_vti_bin/versions.asmx',
				'/_vti_bin/Views.asmx',
				'/_vti_bin/_vti_adm/admin.dll',
				'/_vti_bin/_vti_aut/author.dll',
				'/_vti_bin/owssvr.dll',
				'/_vti_bin/shtml.dll',
				'/_vti_bin/shtml.dll/_vti_rpc',
				'/_vti_bin/WebPartPages.asmx',
				'/_vti_bin/webpartpages.asmx',
				'/_vti_bin/webs.asmx',
				'/_vti_inf.html',
				'/workflowtasks/allitems.aspx',
				'/WPPrevw.aspx',
				]

		vhost = datastore['VHOST'] || datastore['RHOST']

		
		begin
			paths.each do |path|
				full_path = datastore['APP_PATH'] + path
				vprint_status("#{msg} Checking path #{path}")
				check_path(full_path)
			end
		rescue ::Rex::ConnectionError, Errno::ECONNREFUSED
			print_error("#{msg} HTTP Connection Error, Aborting")
		end
	end

	def check_path(path)
		if (datastore['SSL'].to_s.match(/^(t|y|1)/i))
			uri = 'https://' << vhost << path
		else
			uri = 'http://' << vhost << path
		end

		begin
			res = send_request_cgi({
				'encode'	 => false,
				'uri'			=> uri,
				'method'	 => 'GET',
			}, 5)
		rescue ::Rex::ConnectionError, Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::ECONNRESET
			print_error("#{msg} HTTP Connection Failed, Aborting")
			return :abort
		end

		if not res
			print_error("#{msg} HTTP Connection Error, Aborting (No Data)")
			return :abort
		end

		if res.code == 200
			print_good "#{msg} 200 - #{uri}"
		elsif res.code == 302
			print_status "#{msg} 302 - #{uri} (#{res.headers['Location']})"
		elsif res.code == 404 
			print_status "#{msg} 404 - #{uri}"
		else
			print_status "#{msg} #{res.code} - #{uri}"
		end
		
=begin
			report_hash = {
				:host	 => vhost,
				:port	 => datastore['RPORT'],
				:sname	=> 'ad',
				:user	 => user,
				:active => true,
				:type => 'username'}

			report_auth_info(report_hash)
=end

end

	def msg
		"#{vhost}:#{rport } Sharepoint -"
	end

end
