import { createClient } from '@/lib/supabase/server'
import FacilityForm from '@/components/management/FacilityForm'

interface NewFacilityPageProps {
  searchParams: Promise<{ service?: string }>
}

export default async function NewFacilityPage({ searchParams }: NewFacilityPageProps) {
  const { service } = await searchParams
  const supabase = await createClient()

  // Get current logged-in user
  const { data: { user: authUser } } = await supabase.auth.getUser()

  // Fetch current user's data from users table
  const { data: currentUser } = await supabase
    .from('users')
    .select('*')
    .eq('auth_user_id', authUser?.id)
    .single()

  // Fetch master data
  const [
    { data: genres },
    { data: prefectures },
    { data: areas },
    { data: companies },
    { data: services },
    { data: giftCodeAmounts }
  ] = await Promise.all([
    supabase.from('genres').select('*, service_id').order('id'),
    supabase.from('prefectures').select('*').order('id'),
    supabase.from('areas').select('*, prefecture_id').order('id'),
    supabase.from('companies').select('*').order('id'),
    supabase.from('services').select('id, name, code').order('id'),
    supabase.from('gift_code_amounts').select('id, amount').order('amount', { ascending: true })
  ])

  return (
    <div>
      <h1 className="text-2xl font-semibold text-gray-900 mb-6">施設を追加</h1>
      <FacilityForm
        genres={genres || []}
        prefectures={prefectures || []}
        areas={areas || []}
        companies={companies || []}
        services={services || []}
        giftCodeAmounts={giftCodeAmounts || []}
        currentUserType={currentUser?.type || 'admin'}
        defaultServiceId={service ? parseInt(service) : undefined}
      />
    </div>
  )
}
