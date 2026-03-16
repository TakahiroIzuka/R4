import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import ManagementShell from '@/components/management/ManagementShell'

export default async function AdminManagementLayout({
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

  // Only allow 'admin' type to access this management area
  if (currentUser?.type !== 'admin') {
    redirect('/management')
  }

  return (
    <ManagementShell
      currentUserType="admin"
      basePath="/admin-management"
    >
      {children}
    </ManagementShell>
  )
}
