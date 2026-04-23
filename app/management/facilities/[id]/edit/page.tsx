import { notFound } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import FacilityForm from '@/components/management/FacilityForm'
import FacilityEmailPreview from '@/components/management/FacilityEmailPreview'

interface PageProps {
  params: Promise<{
    id: string
  }>
}

export default async function EditFacilityPage({ params }: PageProps) {
  const { id } = await params
  const supabase = await createClient()

  // Get current logged-in user
  const { data: { user: authUser } } = await supabase.auth.getUser()

  // Fetch current user's data from users table
  const { data: currentUser } = await supabase
    .from('users')
    .select('*')
    .eq('auth_user_id', authUser?.id)
    .single()

  // Fetch facility data
  const { data: facility, error } = await supabase
    .from('facilities')
    .select(`
      *,
      facility_genres(genre:genres(id, name, code)),
      detail:facility_details!facility_id(*)
    `)
    .eq('id', id)
    .single()

  if (error || !facility) {
    notFound()
  }

  // Transform facility_genres array to genre_id
  const facilityGenres = facility.facility_genres as Array<{ genre: { id: number; name: string; code: string } }> | undefined
  const firstGenre = facilityGenres?.[0]?.genre
  const facilityWithGenre = {
    ...facility,
    genre_id: firstGenre?.id,
    genre: firstGenre
  }

  // Fetch facility images (excluding logo)
  const { data: images } = await supabase
    .from('facility_images')
    .select('*')
    .eq('facility_id', id)
    .eq('is_logo', false)
    .order('display_order', { ascending: true })

  // Fetch logo image
  const { data: logoData } = await supabase
    .from('facility_images')
    .select('*')
    .eq('facility_id', id)
    .eq('is_logo', true)
    .single()

  // Get public URLs for images
  const imagesWithUrls = (images || []).map(img => {
    const { data: publicData } = supabase.storage
      .from('facility-images')
      .getPublicUrl(img.image_path)

    const thumbnailData = img.thumbnail_path
      ? supabase.storage.from('facility-images').getPublicUrl(img.thumbnail_path)
      : null

    return {
      ...img,
      publicUrl: publicData.publicUrl,
      thumbnailUrl: thumbnailData?.data.publicUrl || null
    }
  })

  // Get public URL for logo (logo uses thumbnail_path for storage)
  const logoWithUrl = logoData?.thumbnail_path ? {
    id: logoData.id,
    facility_id: logoData.facility_id,
    image_path: logoData.thumbnail_path,
    publicUrl: supabase.storage.from('facility-images').getPublicUrl(logoData.thumbnail_path).data.publicUrl
  } : null

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

  const detail = Array.isArray(facility.detail) ? facility.detail[0] : facility.detail
  const service = (services || []).find(s => s.id === facility.service_id)
  const giftAmount = (giftCodeAmounts || []).find(g => g.id === facility.gift_code_amount_id)?.amount ?? null

  return (
    <div>
      <h1 className="text-2xl font-semibold text-gray-900 mb-6">施設を編集</h1>
      <FacilityForm
        genres={genres || []}
        prefectures={prefectures || []}
        areas={areas || []}
        companies={companies || []}
        services={services || []}
        giftCodeAmounts={giftCodeAmounts || []}
        initialData={facilityWithGenre}
        currentUserType={currentUser?.type || 'user'}
        images={imagesWithUrls}
        logo={logoWithUrl}
      />
      <FacilityEmailPreview
        facilityId={facility.id}
        facilityName={detail?.name || ''}
        serviceName={service?.name || ''}
        serviceCode={service?.code || ''}
        googleMapUrl={detail?.google_map_url || null}
        giftCodeAmount={giftAmount}
        facilityUuid={facility.uuid || null}
        baseUrl={process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000'}
        currentUserType={currentUser?.type === 'admin' ? 'admin' : 'user'}
        emailLanguage={facility.email_language || 'ja'}
      />
    </div>
  )
}
