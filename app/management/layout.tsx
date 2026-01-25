import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import AdminSidebar from '@/components/management/AdminSidebar'
import AdminHeader from '@/components/management/AdminHeader'
import { ServiceCode } from '@/lib/constants/services'

export default async function AdminLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const supabase = await createClient()

  // Check if user is authenticated
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    redirect('/auth/login')
  }

  // Fetch current user's data from users table
  const { data: currentUser } = await supabase
    .from('users')
    .select('*')
    .eq('auth_user_id', user?.id)
    .single()

  // Only allow 'user' type to access this management area
  if (currentUser?.type === 'admin') {
    redirect('/admin-management')
  }

  // Fetch facilities and services to determine visible service codes
  const [
    { data: facilities },
    { data: services }
  ] = await Promise.all([
    supabase
      .from('facilities')
      .select('service_id')
      .eq('company_id', currentUser?.company_id),
    supabase
      .from('services')
      .select('id, code')
  ])

  // Get unique service IDs from user's facilities
  const userServiceIds = [...new Set(facilities?.map(f => f.service_id) || [])]

  // Get service codes for user's facilities
  const visibleServiceCodes = services
    ?.filter(s => userServiceIds.includes(s.id))
    .map(s => s.code as ServiceCode) || []

  return (
    <div className="flex min-h-screen bg-[#f0f0f1]">
      <AdminSidebar currentUserType="user" basePath="/management" />
      <div className="flex-1 ml-64">
        <AdminHeader visibleServiceCodes={visibleServiceCodes} />
        <main className="p-6">
          {children}
        </main>
      </div>
    </div>
  )
}
