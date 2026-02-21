import { notFound } from 'next/navigation'
import Header from '@/components/Header'
import Footer from '@/components/Footer'
import QuestionnaireForm from '@/components/QuestionnaireForm'
import { fetchFacilityByUuid } from '@/lib/data/facilities'
import { REVIEW_RANKING_CONFIG, ServiceCode } from '@/lib/constants/services'

interface QuestionnairePageProps {
  params: Promise<{
    serviceCode: string
    uuid: string
  }>
}

export default async function QuestionnairePage({ params }: QuestionnairePageProps) {
  const { serviceCode, uuid } = await params

  const { facility, error } = await fetchFacilityByUuid(uuid, serviceCode)

  if (error || !facility) {
    notFound()
  }

  // Get genre color from REVIEW_RANKING_CONFIG
  const config = REVIEW_RANKING_CONFIG[serviceCode as ServiceCode]
  const genreCode = facility.genre?.code
  const genreColor = genreCode && config?.genres && genreCode in config.genres
    ? (config.genres as Record<string, { color: string; lineColor: string }>)[genreCode].color
    : config?.color || 'rgb(165, 153, 126)'

  return (
    <>
      <Header pageType="detail" />

      <main className="min-h-screen pt-16 md:pt-0" style={{ backgroundColor: 'rgb(242, 240, 236)' }}>
        <div className="pb-2.5 md:pb-32">
          <QuestionnaireForm
            facilityId={facility.id}
            facilityName={facility.name}
            genreColor={genreColor}
            serviceCode={serviceCode}
            googleReviewUrl={facility.google_map_url}
            giftCodeAmount={facility.gift_code_amount?.amount}
          />
        </div>
      </main>

      <Footer backgroundColor="rgb(254, 246, 228)" />
    </>
  )
}
